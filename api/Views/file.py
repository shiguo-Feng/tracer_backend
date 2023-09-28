from datetime import datetime

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from api import models
from api.Serializers.file import FolderModelSerializer, BreadcrumbSerializer, FileSerializer, FileModelSerializer
from api.permissions.permission import IsProjectMember
from api.utils import cos
from django.conf import settings


class BaseProjectView(APIView):
    permission_classes = [IsProjectMember]
    project = None

    def get_project(self):
        if not self.project:
            self.project = models.Project.objects.filter(id=self.kwargs['project_id']).first()
        return self.project


def get_parent_object(request, project_id):
    """
    Retrieve the parent folder object based on the given folder_id and project_id.

    Parameters:
    - request: the current request object.
    - project_id: the ID of the project.

    Returns:
    - The parent folder object or None if not found or if the folder_id is not valid.
    """
    folder_id = request.GET.get('folder', "")
    if folder_id.isdecimal():
        return models.FileRepository.objects.filter(
            id=int(folder_id),
            file_type=2,
            project_id=project_id
        ).first()
    return None


class FolderView(BaseProjectView):

    def get(self, request, project_id):
        parent_object = get_parent_object(request, project_id)

        # Breadcrumbs logic
        breadcrumbs_list = []
        parent = parent_object
        while parent:
            breadcrumbs_list.insert(0, {'id': parent.id, 'name': parent.name})
            parent = parent.parent
        breadcrumbs = BreadcrumbSerializer(breadcrumbs_list, many=True).data

        # File list logic
        queryset = models.FileRepository.objects.filter(project_id=project_id)
        if parent_object:
            # inside some folder
            file_obj_list = queryset.filter(parent=parent_object).order_by('-file_type')
        else:
            # root directory
            file_obj_list = queryset.filter(parent__isnull=True).order_by('-file_type')
        file_objs = FolderModelSerializer(file_obj_list, many=True).data

        # Return combined results
        return Response({
            'breadcrumbs': breadcrumbs,
            'file_objects': file_objs
        }, status.HTTP_200_OK)

    def post(self, request, project_id):
        """
        Handle the creation of a new folder. It sets the project, file type,
        updating user, and parent directory (if any) before saving.

        Parameters:
        - request: the current request object.
        - project_id: the ID of the project to which the folder belongs.

        Returns:
        - A response object with the created folder's serialized data or validation errors.
        """

        # Get the parent object based on the provided parameters.
        parent_object = get_parent_object(request, project_id)

        # Initialize the serializer with the request data and context.
        serializer = FolderModelSerializer(data=request.data, fields=['name'], context={
            "project_id": project_id,
            "parent_object": parent_object
        })

        # Validate and save the folder.
        if serializer.is_valid():
            file_obj = serializer.save(
                project_id=project_id,
                file_type=2,
                update_user_id=request.user.get('id'),
                parent=parent_object
            )
            # Return success
            return Response(FolderModelSerializer(file_obj).data, status=status.HTTP_201_CREATED)

        # Return validation errors if any.
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class FolderDetailView(BaseProjectView):

    def put(self, request, project_id, folder_id):
        folder_obj = models.FileRepository.objects.filter(id=int(folder_id), file_type=2, project_id=project_id).first()
        updated_data = {
            "name": request.data.get("name"),
            "update_user": request.user.get('id')
        }
        serializer = FolderModelSerializer(folder_obj, data=updated_data, partial=True, context={
            'project_id': project_id,
            'parent_object': folder_obj.parent
        })
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, project_id, folder_id):
        # Firstly, ensure the folder exists, and it is of type 'folder'
        delete_obj = models.FileRepository.objects.filter(id=int(folder_id), file_type=2, project_id=project_id).first()
        # project_obj = models.Project.objects.filter(id=project_id).first()
        project_obj = self.get_project()

        if not delete_obj:
            return Response({'detail': 'Folder not found.'}, status=status.HTTP_404_NOT_FOUND)

        total_size = 0
        key_list = []
        folder_list = [delete_obj, ]

        for folder in folder_list:
            child_list = models.FileRepository.objects.filter(project_id=project_id, parent=folder).order_by(
                '-file_type')
            for child in child_list:
                if child.file_type == 2:
                    folder_list.append(child)
                else:
                    total_size += child.file_size
                    key_list.append(child.key)

        if key_list:
            cos.delete_file_batch(key_list)

        if total_size:
            project_obj.use_space -= total_size
            project_obj.save()

        delete_obj.delete()
        return Response(status=status.HTTP_200_OK)


class COSCredentialView(BaseProjectView):

    def post(self, request, project_id):
        """File upload"""
        user_id = request.user.get("id")
        profile = models.Profile.objects.get(user_id=user_id)
        price_policy = profile.price_policy
        project = self.get_project()

        serializer = FileSerializer(data=request.data, many=True)
        if serializer.is_valid():
            file_list = serializer.validated_data
            per_file_limit = price_policy.per_file_size * 1024 * 1024
            total_size = 0

            for item in file_list:
                if item['size'] > per_file_limit:
                    err = "{} exceed single file limit ({}M)".format(item['name'],
                                                                     price_policy.per_file_size)
                    return Response({'error': err}, status=status.HTTP_400_BAD_REQUEST)
                total_size += item['size']

            if project.use_space + total_size > price_policy.project_space * 1024 * 1024:
                return Response(
                    {'error': "exceed total space, please consider free some space"},
                    status=status.HTTP_400_BAD_REQUEST)

            t = cos.gen_upload_token()
            date_path = datetime.now().strftime("%Y/%m/%d/")
            key_prefix = f"{user_id}/{project.id}/{date_path}"
            return Response({'token': t, 'key': key_prefix}, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class FileDetailView(BaseProjectView):
    def delete(self, request, project_id, file_id):
        # First, ensure the file exists, and it's of type 'file'
        delete_obj = models.FileRepository.objects.filter(
            id=file_id,
            file_type=1,
            project_id=project_id
        ).first()

        if not delete_obj:
            return Response({'detail': 'File not found.'}, status=status.HTTP_404_NOT_FOUND)

        # Update the project space used
        project_obj = self.get_project()
        project_obj.use_space -= delete_obj.file_size
        project_obj.save()

        # For demo user, don't delete file on cos
        # Delete the file in the COS storage
        if request.user.get('role') == 'normal':
            cos.delete_file(delete_obj.key)

        # Delete the file in the database
        delete_obj.delete()

        return Response(status=status.HTTP_200_OK)

    def post(self, request, project_id, file_id):
        # Query for the FileRepository object
        file_obj = models.FileRepository.objects.filter(
            id=file_id,
            file_type=1,
            project_id=project_id
        ).first()

        # If the object does not exist, return a 404
        if not file_obj:
            return Response({'detail': 'File not found.'}, status=status.HTTP_404_NOT_FOUND)

        # Retrieve the download path and return it
        download_path = cos.generate_temporary_url(file_obj.key, file_obj.name)
        return Response({'download_path': download_path}, status=status.HTTP_200_OK)


class FilePostView(BaseProjectView):

    def post(self, request, project_id):
        """
        Handle the creation of a new file entry in the database.

        Parameters:
        - request: the current request object.
        - project_id: the ID of the project to which the file belongs.

        Returns:
        - A response object with the created file's serialized data or validation errors.
        """

        data = request.data.copy()
        data['file_path'] = "{}/{}".format(settings.AWS_S3_CUSTOM_DOMAIN, data['key'])

        serializer = self.get_serializer(data=data)

        if serializer.is_valid():
            instance = serializer.save(
                project_id=project_id,
                file_type=1,
                parent_id=data.get('parent_id'),
                update_user_id=request.user.get('id')
            )

            # Update the project's used space.
            project = self.get_project()
            project.use_space += instance.file_size
            project.save()

            return Response(status=status.HTTP_201_CREATED)

        return Response({'data': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

    def get_serializer(self, *args, **kwargs):
        return FileModelSerializer(*args, **kwargs)
