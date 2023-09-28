from rest_framework import serializers
from api.models import Project, Module


class StatsProjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Project
        fields = ['name', 'desc', 'use_space', 'create_datetime']


class ModuleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Module
        fields = '__all__'
