# -*- coding: utf-8 -*-
# flake8: noqa
import boto3
from botocore.config import Config
from botocore.exceptions import NoCredentialsError
from Tracer_Api import settings
import os
from datetime import datetime
import uuid

# Initialize the S3 client at the module level
s3_client = boto3.client(
    's3',
    aws_access_key_id=settings.AWS_ACCESS_KEY_ID,
    aws_secret_access_key=settings.AWS_SECRET_ACCESS_KEY,
)
BUCKET_NAME = settings.AWS_STORAGE_BUCKET_NAME


def object_upload_path(request, obj, project_id, public_folder=False):
    # Generate date-based path
    date_path = datetime.now().strftime("%Y/%m/%d/")
    # Generate UUID as file name
    file_name = str(uuid.uuid4().hex)

    # Combine path and file name
    if public_folder:
        base_path = f"public_images/{request.user.get('id')}/{project_id}/{date_path}"
    else:
        base_path = f"{request.user.get('id')}/{project_id}/{date_path}"

    file_path = os.path.join(base_path, file_name)

    ext = obj.name.rsplit('.')[-1]
    key = "{}.{}".format(file_path, ext)

    return key


def upload_cos(request, obj, project_id):
    # Calculate the file path where the object will be stored on S3.
    filepath = object_upload_path(request, obj, project_id, public_folder=True)

    # Read the content of the file from the UploadedFile object.
    file_content = obj.read()

    # Use the put_object method to upload the file content to S3.
    s3_client.put_object(
        Body=file_content,
        Bucket=BUCKET_NAME,
        Key=filepath
    )

    # Return the complete URL where the object can be accessed on S3.
    return "{}/{}".format(settings.AWS_S3_CUSTOM_DOMAIN, filepath)


def delete_file(file_key):
    try:
        response = s3_client.delete_object(Bucket=BUCKET_NAME, Key=file_key)
    except NoCredentialsError:
        print("Credentials not available")
    except Exception as e:
        print("An error occurred:", e)


def delete_file_batch(key_list):
    # Build the delete structure
    delete_struct = {
        'Objects': [{'Key': k} for k in key_list],
        'Quiet': True
    }

    # Execute the batch delete
    response = s3_client.delete_objects(
        Bucket=BUCKET_NAME,
        Delete=delete_struct
    )
    return response


def check_file(file_key):
    response = s3_client.head_object(Bucket=BUCKET_NAME, Key=file_key)
    return response


def gen_upload_token():
    sts_client = boto3.client('sts',
                              aws_access_key_id=settings.AWS_ACCESS_KEY_ID,
                              aws_secret_access_key=settings.AWS_SECRET_ACCESS_KEY
                              )
    role_arn = settings.AWS_IAM_ROLE_ARN

    assumed_role_object = sts_client.assume_role(
        RoleArn=role_arn,
        RoleSessionName="AssumeRoleSession1",
        DurationSeconds=900
    )

    credentials = assumed_role_object['Credentials']
    return credentials


def generate_temporary_url(file_key, file_name, expiration=900):
    """
    Generate a temporary download URL for a given file key on S3.

    :param file_key: The S3 key for the desired file.
    :param expiration: Duration for which the URL remains valid (default is 3600 seconds, or 1 hour).
    :return: Temporary URL.
    """
    s3 = boto3.client('s3',
                      aws_access_key_id=settings.AWS_ACCESS_KEY_ID,
                      aws_secret_access_key=settings.AWS_SECRET_ACCESS_KEY,
                      region_name='ca-central-1',
                      config=Config(signature_version='s3v4'))
    try:
        # Use Boto3's generate_presigned_url method to produce the temporary URL
        url = s3.generate_presigned_url(
            'get_object',
            Params={'Bucket': BUCKET_NAME,
                    'Key': file_key,
                    'ResponseContentDisposition': 'attachment; filename={}'.format(file_name)
                    },
            ExpiresIn=expiration
        )
        return url
    except Exception as e:
        print("Error generating URL:", e)
        return None


def delete_folder(folder_name):
    # Define the prefix for objects in the "folder"
    folder_prefix = '{}/'.format(folder_name)

    # List all objects under the given folder prefix
    result = s3_client.list_objects_v2(Bucket=settings.BUCKET_NAME, Prefix=folder_prefix)

    # Check if there are any objects to delete
    if result.get('Contents'):
        # Create a list of objects to delete
        delete_dict = {
            'Objects': [{'Key': item['Key']} for item in result['Contents']]
        }

        # Perform batch delete
        s3_client.delete_objects(Bucket=settings.BUCKET_NAME, Delete=delete_dict)
