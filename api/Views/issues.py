import datetime
import uuid

from django.utils import timezone
from rest_framework.generics import RetrieveUpdateAPIView, get_object_or_404, ListCreateAPIView
from rest_framework.pagination import PageNumberPagination
from rest_framework.reverse import reverse
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth.models import User

from api import models
from api.Serializers.issues import IssuesChoicesSerializer, IssuesModelSerializer, IssueEditSerializer, \
    IssuesReplyModelSerializer, ProjectInviteSerializer
from api.permissions.permission import IsProjectMember
from api.utils.issue_filter import IssuesFilter

DISPLAY_FIELDS = [
    # Primary fields
    'id',
    'project_issue_id',

    # Issue details
    'subject',
    'priority_data',
    'end_date',
    'latest_update_datetime',

    # Related objects
    'issues_type_title',
    'status_display',

    # User-related fields
    'assign_name',
    'creator_name'
]


class IssuesChoicesView(APIView):
    """
    This view will list available choices for fields like
    issues_type, module, assign, attention, and parent within a project.
    """
    permission_classes = [IsProjectMember]

    def get(self, request, project_id, issues_id=None):
        """
        Handle GET requests to provide choice fields for issues within a project.
        Obtain the specific project through the provided project_id.

        Parameters:
        - request: HTTP GET Request
        - project_id: ID of the project to get the issues choices for.
        - issues_id: Optional, ID of a specific issue. If provided, this issue will be excluded from the parent choices.

        Returns:
        A Response object containing the serialized choices if the serializer is valid, else returns a 400 Bad Request response with the serialization errors.
        """
        project = models.Project.objects.get(id=project_id)

        # Set choices for 'issues_type'
        issues_type_choices = models.IssuesType.objects.filter(project=project).values_list('id', 'title')

        # Set choices for 'module', including a default "None" option
        module_choices = [("", "None")]
        module_obj_list = list(models.Module.objects.filter(project=project).values_list('id', 'title'))
        module_choices.extend(module_obj_list)

        # Set choices for 'assign' and 'attention', starting with the project creator
        all_user_list = [(project.creator_id, project.creator.user.username)]
        project_user_list = models.ProjectUser.objects.filter(project=project).values_list('user_id',
                                                                                           'user__user__username')
        all_user_list.extend(project_user_list)

        # assign_choices = [("", "None")]
        # assign_choices.extend(all_user_list)
        assign_choices = all_user_list
        attention_choices = all_user_list

        # Set choices for 'parent' field, including a default "None" option
        issue_list = [("", "None")]
        issue_obj_list = models.Issues.objects.filter(project=project).exclude(id=issues_id).values_list('id',
                                                                                                         'subject')
        issue_list.extend(issue_obj_list)

        context = {
            'issues_type_choices': issues_type_choices,
            'module_choices': module_choices,
            'assign_choices': assign_choices,
            'attention_choices': attention_choices,
            'parent_choices': issue_list
        }

        # Serializing the context data
        serializer = IssuesChoicesSerializer(data={}, context=context)
        if serializer.is_valid():
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class IssuesView(APIView):
    """
    An API view to handle the retrieval and creation of issues associated with a specific project.
    """

    permission_classes = [IsProjectMember]
    filterset_class = IssuesFilter

    def get(self, request, project_id):
        """
        Handles GET requests to retrieve a list of issues associated with the specified project_id.

        Parameters:
        - request: HTTP GET Request
        - project_id: ID of the project whose issues are to be retrieved.

        Returns:
        A paginated response containing the serialized list of issues if any.
        """

        queryset = models.Issues.objects.filter(project_id=project_id).order_by('id')

        # Apply the filters using filterset_class
        issues_filter = self.filterset_class(request.GET, queryset=queryset)
        queryset = issues_filter.qs

        # Apply pagination
        paginator = PageNumberPagination()
        paginator.page_size = 10  # Set page size here
        paginated_queryset = paginator.paginate_queryset(queryset, request)

        # Serializing the paginated queryset
        serializer = IssuesModelSerializer(
            paginated_queryset,
            many=True,
            fields=DISPLAY_FIELDS
        )

        return paginator.get_paginated_response(serializer.data)

    def post(self, request, project_id):
        """
        Handles POST requests to create a new issue associated with the specified project_id.

        Parameters:
        - request: HTTP POST Request containing the data for the new issue.
        - project_id: ID of the project in which the issue is to be created.

        Returns:
        A Response object containing the serialized data of the created issue if the serializer is valid,
        else returns a 400 Bad Request response with the serialization errors.
        """

        # Serializing the received data
        serializer = IssuesModelSerializer(
            data=request.data,
            exclude=['project', 'creator', 'create_datetime', 'project_issue_id', 'latest_update_datetime']
        )

        # Validating the serialized data
        if serializer.is_valid():
            # Saving the instance with additional fields
            serializer.save(
                project_id=project_id,
                creator_id=request.user.get('id')
            )
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class IssueDetailView(RetrieveUpdateAPIView):
    """
    API View to handle the retrieval and update of individual issue details,
    ensuring the user with the specified project_id.
    """
    queryset = models.Issues.objects.all()
    serializer_class = IssueEditSerializer
    permission_classes = [IsProjectMember]

    def get_queryset(self):
        """
        Customize the base queryset to fetch only the issues that belong to the given project_id.
        """
        return self.queryset.filter(project_id=self.kwargs['project_id'])

    def update(self, request, *args, **kwargs):
        """
        Handle the update of the issue, compare the original data with updated data,
        and generate operation records for the changed fields.
        """

        # Step 1: Get the original data
        instance = self.get_object()
        original_data = self.get_serializer(instance).data

        # Step 2: Use the serializer to validate and update the data
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        if serializer.is_valid():
            self.perform_update(serializer)

            # Step 3: Compare the original data with the updated data to determine which fields changed
            updated_data = serializer.data
            changed_fields = {}
            for field, value in updated_data.items():
                if original_data[field] != value:
                    changed_fields[field] = {"original": original_data[field], "updated": value}

            # Step 4: Generate operation records for the changed fields
            change_descriptions = []
            for field, change in changed_fields.items():
                if field in ['start_date', 'end_date'] and change['updated']:
                    # Date
                    change['updated'] = change['updated'][:10]  # Only date from datetime obj
                elif field == 'assign':
                    # Fetch usernames of the original and updated assignees, and append the change description
                    original_user = User.objects.get(id=change['original']).username if change['original'] else "None"
                    updated_user = User.objects.get(id=change['updated']).username if change['updated'] else "None"
                    change_descriptions.append(f"{field} was updated from {original_user} to {updated_user}")
                    continue
                elif field in ['issues_type', 'module', 'parent']:
                    # Foreign Keys

                    # Get Model Object
                    related_model = models.Issues._meta.get_field(field).related_model
                    # original and updated objects string representation
                    original_obj_str = str(get_object_or_404(related_model, id=change['original'])) if change[
                        'original'] else "None"
                    updated_obj_str = str(get_object_or_404(related_model, id=change['updated'])) if change[
                        'updated'] else "None"
                    change_descriptions.append(f"{field} was updated from {original_obj_str} to {updated_obj_str}")
                    continue
                elif field in ['priority', 'status', 'mode']:
                    # choice representation
                    choices_dict = dict(models.Issues._meta.get_field(field).choices)
                    original_text = choices_dict.get(change['original'], "None")
                    updated_text = choices_dict.get(change['updated'], "None")
                    change_descriptions.append(f"{field} was updated from {original_text} to {updated_text}")
                    continue
                elif field == 'attention':
                    # Fetch the list of user IDs and their corresponding usernames for the 'attention' field
                    # and append the change description

                    # Original and Updated User id List
                    original_user_ids = change['original'] or []
                    updated_user_ids = change['updated'] or []

                    # Get usernames
                    original_usernames = [User.objects.get(id=user_id).username for user_id in original_user_ids]
                    updated_usernames = [User.objects.get(id=user_id).username for user_id in updated_user_ids]

                    # Joined by comma
                    original_users_str = ', '.join(original_usernames) or "None"
                    updated_users_str = ', '.join(updated_usernames) or "None"

                    change_descriptions.append(f"{field} was updated from {original_users_str} to {updated_users_str}")
                    continue

                # Generating a change record from all the individual change descriptions
                change_descriptions.append(f"{field} was updated from \"{change['original']}\" to \"{change['updated']}\"")

            change_record_content = ";\n".join(change_descriptions)

            # Creating a new issue reply to record the change details
            models.IssuesReply.objects.create(
                reply_type=1,
                issues=instance,
                content=change_record_content,
                creator_id=request.user.get('id')
            )

            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class IssueReplyView(APIView):
    """
    View to handle the retrieval and creation of issue replies.
    Permissions are checked before processing requests.
    """

    permission_classes = [IsProjectMember]

    def get(self, request, project_id, issues_id):
        """
        Handle GET requests.
        Fetch and return all replies for the given issue and project in JSON format.
        """

        queryset = models.IssuesReply.objects.filter(issues_id=issues_id, issues__project_id=project_id)
        serializer = IssuesReplyModelSerializer(queryset, many=True)

        return Response(serializer.data)

    def post(self, request, project_id, issues_id):
        """
        Handle POST requests.
        Validate and create a new Issue Reply instance, then return the created instance in JSON format.
        If the data is invalid, return an error response with validation errors.
        """

        serializer = IssuesReplyModelSerializer(
            data=request.data,
        )

        # Validate data
        if serializer.is_valid():
            # Save the instance
            serializer.save(
                issues_id=issues_id,
                reply_type=2,
                creator_id=request.user.get('id')
            )
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class ProjectInviteView(ListCreateAPIView):
    """
    API view to handle the listing and creation of Project Invites.
    Handles GET requests to list existing invites and POST requests to create new invites.
    """
    queryset = models.ProjectInvite.objects.all()
    serializer_class = ProjectInviteSerializer
    permission_classes = [IsProjectMember]

    def list(self, request, *args, **kwargs):
        """
        Handle GET requests to list period choices for Project Invites.
        Returns the available period_choices for the frontend in JSON format.
        """
        return Response(models.ProjectInvite.period_choices, status=status.HTTP_200_OK)

    def create(self, request, *args, **kwargs):
        """
        Handle POST requests to create a new Project Invite instance.
        Validates the provided data, generates a unique invite code using UUID,
        and saves the instance to the database. Returns the created invite code in JSON format.

        Only the creator of the project can invite. If the user has no permission to create an invitation code,
        a 403 Forbidden response is returned.

        If the provided data is invalid, returns a 400 Bad Request response with validation errors.
        """
        project_obj = models.Project.objects.filter(id=self.kwargs['project_id']).first()
        serializer = self.get_serializer(data=request.data)

        if serializer.is_valid():
            # Only the creator can invite
            if request.user.get('id') != project_obj.creator.user_id:
                return Response({'error': "No permission to create invite code"},
                                status=status.HTTP_403_FORBIDDEN)

            # Generate a random invite code using UUID
            random_invite_code = str(uuid.uuid4())

            # Save to database
            serializer.save(
                code=random_invite_code,
                project=project_obj,
                creator_id=request.user.get('id')
            )

            return Response({'data': random_invite_code}, status=status.HTTP_201_CREATED)

        return Response({'error': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


class ProjectJoinView(APIView):
    """
    API view to handle the joining of a project by a user.
    Handles POST requests to join a user to a project based on the provided invitation code.
    """

    permission_classes = []

    def post(self, request, code):
        """
        Handle POST requests to join a user to a project.
        Validates the invitation code, checks if the user has already joined the project,
        and if not, adds the user to the project.

        Returns a 404 Not Found response if the invitation code does not exist.
        Returns a 400 Bad Request response if the user has already joined the project,
        if the invitation code has expired, or if the invitation code has been used up.

        If successful, returns a 200 OK response with the project name and a success message in JSON format.
        """
        current_datetime = datetime.datetime.now()
        aware_utc_datetime = timezone.make_aware(current_datetime, timezone=timezone.utc)

        invite_object = models.ProjectInvite.objects.filter(code=code).first()
        if not invite_object:
            return Response({'error': 'Invitation code does not exist'}, status=status.HTTP_404_NOT_FOUND)

        if invite_object.project.creator_id == request.user.get('id'):
            return Response({'error': 'Creator does not need to join the project again'}, status=status.HTTP_400_BAD_REQUEST)

        exists = models.ProjectUser.objects.filter(project=invite_object.project, user_id=request.user.get('id')).exists()
        if exists:
            return Response({'error': 'Already joined the project'}, status=status.HTTP_400_BAD_REQUEST)

        # Invitation code expiration check
        limit_datetime = invite_object.create_datetime + datetime.timedelta(minutes=invite_object.period)
        if aware_utc_datetime > limit_datetime:
            return Response({'error': 'Invitation code has expired'}, status=status.HTTP_400_BAD_REQUEST)

        # Quantity limit check
        if invite_object.count:
            if invite_object.use_count >= invite_object.count:
                return Response({'error': 'Invitation code has been used up'}, status=status.HTTP_400_BAD_REQUEST)
            invite_object.use_count += 1
            invite_object.save()

        models.ProjectUser.objects.create(user_id=request.user.get('id'), project=invite_object.project)
        invite_object.project.join_count += 1
        invite_object.project.save()

        return Response({'project': invite_object.project.name, 'message': 'Successfully joined the project'}, status=status.HTTP_200_OK)