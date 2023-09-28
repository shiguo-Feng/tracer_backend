from rest_framework import serializers
from api.models import Wiki
from api.Serializers.dynamic import DynamicFieldsModelSerializer


class WikiSerializer(DynamicFieldsModelSerializer):
    # parent_choices = serializers.SerializerMethodField()

    class Meta:
        model = Wiki
        # exclude = ['project', 'depth']
        fields = '__all__'
