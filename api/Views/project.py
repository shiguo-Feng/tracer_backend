from rest_framework.generics import GenericAPIView, ListCreateAPIView, get_object_or_404
from rest_framework import status
from rest_framework.response import Response
from rest_framework.mixins import UpdateModelMixin
from django.db.models import Q

from api.Serializers.project import ProjectSerializer, ProjectUserSerializer
from api.models import Project, Profile, ProjectUser, IssuesType


class ProjectView(ListCreateAPIView):
    """
        A view that extends ListCreateAPIView to handle the retrieval of a list of projects associated with the current user
        and the creation of new projects.
        """
    serializer_class = ProjectSerializer

    def get_queryset(self):
        """
        Overrides the get_queryset method to return a queryset containing all projects where the current user is either
        the creator or a member.
        """
        user_id = self.request.user.get('id')
        return Project.objects.filter(Q(creator_id=user_id) | Q(projectuser__user_id=user_id)).distinct()

    def create(self, request, *args, **kwargs):
        """
        Overrides the create method to handle the creation of a new project.

        It retrieves the current user's profile, initializes the serializer with the provided data and the creator's user_id.
        If the serializer is valid, it performs the creation of the project and initializes the default issue types for the project.

        Returns a 201 Created response with the serialized project data if the project is created successfully.
        Returns a 400 Bad Request response with the serialization errors if the provided data is invalid.
        """

        # get profile id
        user_id = self.request.user.get('id')
        profile = get_object_or_404(Profile, user_id=user_id)

        # data is supposed to be immutable
        data = request.data.copy()
        data['creator'] = profile.user_id

        serializer = self.get_serializer(data=data)
        if serializer.is_valid(raise_exception=True):
            self.perform_create(serializer)
            project_instance = serializer.instance

            # Initializing default issue types
            issues_type_object_list = []
            type_list = IssuesType.PROJECT_INIT_LIST
            for title in type_list:
                issues_type_object_list.append(IssuesType(project=project_instance, title=title))
            IssuesType.objects.bulk_create(issues_type_object_list)

            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class ProjectDetailView(GenericAPIView, UpdateModelMixin):
    """
    The view ensures that only the creator of the project has the permission to star their own project.
    """

    queryset = Project.objects.all()
    serializer_class = ProjectSerializer

    def put(self, request, pk):
        return self.partial_update(request, pk)

    def check_object_permissions(self, request, obj):
        # only creator can star their own project
        if request.user.get('id') != obj.creator.user.id:
            self.permission_denied(request)


class JoinedProjectStarView(GenericAPIView, UpdateModelMixin):
    """
    The view ensures that only members of the project has the permission to star their own project.
    """

    queryset = ProjectUser.objects.all()
    serializer_class = ProjectUserSerializer
    lookup_field = 'project_id'

    def put(self, request, project_id):
        update_obj = get_object_or_404(ProjectUser.objects.filter(project_id=project_id, user__user_id=request.user.get('id')))

        return self.partial_update(request, update_obj.id)  # Passing the correct pk

    def check_object_permissions(self, request, obj):
        # only joined members can star
        if request.user.get('id') != obj.user.user_id:
            self.permission_denied(request)