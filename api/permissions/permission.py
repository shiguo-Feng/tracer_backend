from django.db.models import Q
from rest_framework.permissions import BasePermission
from api import models


class IsProjectMember(BasePermission):
    def has_permission(self, request, view):
        # Retrieve project_id from the view
        project_id = view.kwargs.get('project_id')
        request_user_id = request.user.get('id')

        # If project_id is provided, check if the user is a member of the project
        if project_id:
            # Check if the user is either the creator of the project or has joined the project
            is_member = models.Project.objects.filter(
                Q(id=project_id, creator_id=request_user_id) |
                Q(id=project_id, projectuser__user_id=request_user_id)
            ).exists()

            return is_member

        # Return False by default if no project_id is provided
        return False
