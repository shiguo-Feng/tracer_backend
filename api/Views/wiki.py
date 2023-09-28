from rest_framework.views import APIView
from rest_framework.generics import GenericAPIView, RetrieveAPIView, RetrieveUpdateDestroyAPIView
from rest_framework.response import Response
from rest_framework import status

from api.Serializers.wiki import WikiSerializer
from api import models
from api.permissions.permission import IsProjectMember


class WikiView(APIView):
    permission_classes = [IsProjectMember]

    def get_parent_choices(self, project):
        data_list = models.Wiki.objects.filter(project=project).values_list('id', 'title')
        total_data_list = [(None, "None")]
        total_data_list.extend(data_list)
        return total_data_list

    def get(self, request, project_id):
        project = models.Project.objects.get(id=project_id)
        return Response({'parent_choices': self.get_parent_choices(project)})

    def post(self, request, project_id):
        project = models.Project.objects.get(id=project_id)
        serializer = WikiSerializer(data=request.data, exclude=['project', 'depth'])

        if serializer.is_valid():
            if serializer.validated_data.get('parent'):
                depth = serializer.validated_data['parent'].depth + 1
            else:
                depth = 1

            wiki_obj = serializer.save(project=project, depth=depth)
            return Response(WikiSerializer(wiki_obj).data)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class WikiDetailView(RetrieveUpdateDestroyAPIView):
    permission_classes = [IsProjectMember]

    queryset = models.Wiki.objects.all()
    serializer_class = WikiSerializer

    def get_serializer(self, *args, **kwargs):
        """ Override get_serializer to pass custom fields to the serializer """
        kwargs['fields'] = ['id', 'title', 'content', 'parent']
        return super(WikiDetailView, self).get_serializer(*args, **kwargs)

    def get_queryset(self):
        """ Fetch only the wikis that belong to the given project_id."""
        return self.queryset.filter(project_id=self.kwargs['project_id'])

    def perform_update(self, serializer):
        parent = serializer.validated_data.get('parent')

        # Check if the new parent is present and update the depth
        if parent:
            depth = parent.depth + 1
        else:
            depth = 1

        # Update the depth on the instance and save
        instance = serializer.save(depth=depth)


class WikiCatalogView(APIView):
    permission_classes = [IsProjectMember]

    def get(self, request, project_id):
        wikis = models.Wiki.objects.filter(project_id=project_id).order_by('depth', 'id')
        # Use wiki serializer, and dynamically set filed.
        serializer = WikiSerializer(wikis, many=True, fields=('id', 'title', 'parent'))
        return Response({'data': serializer.data}, status=status.HTTP_200_OK)


from api.Serializers.img import FileUploadSerializer
from api.utils import cos


class WikiUploadView(APIView):
    permission_classes = [IsProjectMember]

    def post(self, request, project_id):
        serializer = FileUploadSerializer(data=request.data)
        if serializer.is_valid():
            img_obj = serializer.validated_data.get('file')
            img_url = cos.upload_cos(request, img_obj, project_id)
            return Response({'url': img_url}, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
