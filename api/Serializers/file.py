from django.contrib.auth.models import User
from django.db.models import Q
from rest_framework import serializers

from api.Serializers.dynamic import DynamicFieldsModelSerializer
from api.models import FileRepository
from api.utils import cos


class FolderModelSerializer(DynamicFieldsModelSerializer):
    updater_name = serializers.SerializerMethodField('get_updater_name')

    class Meta:
        model = FileRepository
        fields = '__all__'

    def get_updater_name(self, obj):
        """Retrieve the username for the 'updater' field."""
        if isinstance(obj.update_user.user, User):
            return obj.update_user.user.username
        return None

    def validate(self, data):
        name = data.get('name')
        project_id = self.context.get("project_id")
        parent_object = self.context.get("parent_object")

        #     queryset = FileRepository.objects.filter(file_type=2, name=name, project=project_id)
        #
        #     if parent_object:
        #         exists = queryset.filter(parent=parent_object).exists()
        #     else:
        #         exists = queryset.filter(parent__isnull=True).exists()
        duplicate_filter = Q(file_type=2, name=name, project=project_id)
        if parent_object:
            duplicate_filter &= Q(parent=parent_object)
        else:
            duplicate_filter &= Q(parent__isnull=True)

        if FileRepository.objects.filter(duplicate_filter).exists():
            raise serializers.ValidationError({'name': 'Duplicate name'})

        return data


class BreadcrumbSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    name = serializers.CharField()


class FileSerializer(serializers.Serializer):
    name = serializers.CharField(max_length=255)
    size = serializers.IntegerField()


class FileModelSerializer(serializers.ModelSerializer):
    etag = serializers.CharField()

    class Meta:
        model = FileRepository
        exclude = ['project', 'parent', 'file_type', 'update_user', 'update_datetime']

    def save(self, **kwargs):
        self.validated_data.pop('etag', None)
        return super().save(**kwargs)

    def validate(self, data):
        key = data['key']
        etag = data['etag']
        size = data['file_size']

        if not key or not etag:
            return data

        try:
            result = cos.check_file(key)
        except Exception as e:
            raise serializers.ValidationError({'key': 'File NOT EXIST'})

        cos_etag = result.get('ETag')
        if etag != cos_etag:
            raise serializers.ValidationError({'etag': 'Wrong etag'})

        cos_size = result.get('ContentLength')
        if size != cos_size:
            raise serializers.ValidationError({'file_size': 'Wrong size'})

        return data
