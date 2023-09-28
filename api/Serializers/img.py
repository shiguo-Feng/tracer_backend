import os

from rest_framework import serializers


class FileUploadSerializer(serializers.Serializer):
    file = serializers.FileField()

    def validate_file(self, value):
        """
        Validate the uploaded file to ensure it's an image and its size is less than or equal to 1MB.
        """
        # List of allowed image extensions
        allowed_extensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff', '.webp']
        ext = os.path.splitext(value.name)[1]  # Extract the file extension
        if ext.lower() not in allowed_extensions:
            raise serializers.ValidationError('Unsupported file extension. Allowed extensions are: {}'.format(', '.join(allowed_extensions)))

        # Validate file size
        if value.size > 1024 * 1024:  # 1MB
            raise serializers.ValidationError('The uploaded file size exceeds the 1MB limit.')

        return value
