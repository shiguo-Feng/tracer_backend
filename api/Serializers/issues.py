from rest_framework import serializers
from api import models
from django.contrib.auth.models import User
from api.Serializers.dynamic import DynamicFieldsModelSerializer


class IssuesChoicesSerializer(serializers.Serializer):
    issues_type_choices = serializers.SerializerMethodField()
    module_choices = serializers.SerializerMethodField()
    assign_choices = serializers.SerializerMethodField()
    attention_choices = serializers.SerializerMethodField()
    parent_choices = serializers.SerializerMethodField()

    priority_choices = serializers.SerializerMethodField()
    status_choices = serializers.SerializerMethodField()
    mode_choices = serializers.SerializerMethodField()

    def get_issues_type_choices(self, obj):
        return self.context['issues_type_choices']

    def get_module_choices(self, obj):
        return self.context['module_choices']

    def get_assign_choices(self, obj):
        return self.context['assign_choices']

    def get_attention_choices(self, obj):
        return self.context['attention_choices']

    def get_parent_choices(self, obj):
        return self.context['parent_choices']

    def get_priority_choices(self, obj):
        return models.Issues.priority_choices

    def get_status_choices(self, obj):
        return models.Issues.status_choices

    def get_mode_choices(self, obj):
        return models.Issues.mode_choices


class IssuesModelSerializer(DynamicFieldsModelSerializer):
    issues_type_title = serializers.SerializerMethodField()
    status_display = serializers.SerializerMethodField()
    assign_name = serializers.SerializerMethodField()
    creator_name = serializers.SerializerMethodField()
    priority_data = serializers.SerializerMethodField()

    class Meta:
        model = models.Issues
        fields = '__all__'

    def get_issues_type_title(self, obj):
        if isinstance(obj.issues_type, models.IssuesType):
            return obj.issues_type.title
        return None

    def get_status_display(self, obj):
        return obj.get_status_display()

    def get_assign_name(self, obj):
        if obj.assign:
            return obj.assign.user.username
        return None

    def get_creator_name(self, obj):
        if isinstance(obj.creator.user, User):
            return obj.creator.user.username
        return None

    def get_priority_data(self, obj):
        return {
            "color": obj.priority,
            "label": obj.get_priority_display()
        }


class IssueEditSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Issues
        exclude = ['project', 'creator', 'create_datetime', 'project_issue_id', 'latest_update_datetime']

    def validate_assign(self, value):
        """
        Check that assign is either the project creator or a project participant.
        """
        if value is None:
            return value

        project_id = self.context['view'].kwargs['project_id']
        project = models.Project.objects.filter(id=project_id).first()

        # Check if project creator
        if value.user_id == project.creator.user_id:
            return value

        project_user_object = models.ProjectUser.objects.filter(project_id=project_id, user_id=value.user_id).first()
        if project_user_object:
            # Check if joined project member
            return value

        raise serializers.ValidationError("You can only assign to the project creator or a project participant.")

    def validate_attention(self, value):
        """
        Validate that the provided user IDs are valid members of the project.
        """
        project_id = self.context['view'].kwargs['project_id']
        project = models.Project.objects.filter(id=project_id).first()

        user_ids = [user.user_id for user in value]

        valid_user_ids = {project.creator.user_id}
        project_user_ids = set(
            models.ProjectUser.objects.filter(project_id=project_id).values_list('user_id', flat=True))
        valid_user_ids.update(project_user_ids)

        if not set(user_ids).issubset(valid_user_ids):
            raise serializers.ValidationError("One or more provided users are not valid members of the project.")

        return value


class IssuesReplyModelSerializer(DynamicFieldsModelSerializer):
    creator_name = serializers.SerializerMethodField()
    creator_id = serializers.SerializerMethodField()
    reply_type_text = serializers.SerializerMethodField()

    class Meta:
        model = models.IssuesReply
        exclude = ['creator', 'issues', 'reply_type']

    def get_creator_name(self, obj):
        if isinstance(obj.creator.user, User):
            return obj.creator.user.username
        return None

    def get_creator_id(self, obj):
        if isinstance(obj.creator.user, User):
            return obj.creator.user_id
        return None

    def get_reply_type_text(self, obj):
        return obj.get_reply_type_display()


class ProjectInviteSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.ProjectInvite
        fields = ['period', 'count']
