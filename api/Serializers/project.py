from rest_framework import serializers
from api.models import Project, Profile, ProjectUser
from django.contrib.auth.models import User


class ProjectSerializer(serializers.ModelSerializer):
    color_display = serializers.SerializerMethodField('get_color_display')
    creator_name = serializers.SerializerMethodField('get_creator_name')
    type = serializers.SerializerMethodField()
    user_star = serializers.SerializerMethodField()

    class Meta:
        model = Project
        fields = '__all__'

    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation.pop('color', None)  # Remove the color field
        representation.pop('creator', None)  # Remove the creator field
        return representation

    def get_color_display(self, obj):
        """Retrieve the actual color value for the 'color' field."""
        return dict(Project.COLOR_CHOICES).get(obj.color, '')

    def get_creator_name(self, obj):
        """Retrieve the username for the 'creator' field."""
        if isinstance(obj.creator.user, User):
            return obj.creator.user.username
        return None

    def get_type(self, obj):
        """Determine if the project is created by the authenticated user or if they just joined it."""
        user_id = self.context['request'].user.get('id')
        if obj.creator.user_id == user_id:
            return "my"
        return "joined"

    def get_user_star(self, obj):
        """Get the star status of the project for the current user."""
        user_id = self.context['request'].user.get('id')
        if obj.creator.user_id == user_id:
            return obj.star
        project_user = ProjectUser.objects.filter(user_id=user_id, project=obj).first()
        return project_user.star if project_user else False

    def validate_name(self, value):
        """Hook Function for project name"""

        # 1.Duplicate name check
        user_id = self.context['request'].user.get('id')

        flag = Project.objects.filter(name=value, creator_id=user_id).exists()
        if flag:
            # Current User have duplicate project name
            raise serializers.ValidationError("Duplicate project name")

        # 2.User have spare project num
        count = Project.objects.filter(creator_id=user_id).count()

        try:
            user_profile = Profile.objects.get(user_id=user_id)
            max_projects = user_profile.price_policy.project_num
        except Profile.DoesNotExist:
            raise serializers.ValidationError('No profile exists for the user')

        if count >= max_projects:
            raise serializers.ValidationError('Reached maximum project amount, please Upgrade')

        return value


class ProjectUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProjectUser
        fields = '__all__'
