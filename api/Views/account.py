import requests
import redis
from rest_framework import viewsets, status, permissions
from django.contrib.auth.models import User
from rest_framework.generics import RetrieveUpdateAPIView
from rest_framework.permissions import AllowAny

from api.models import Profile
from api.utils.demo_user import restore_schema_to_new_schema
from api.utils.jwt_auth import create_token
from rest_framework.response import Response
from api.Serializers.account import UserSerializer, AvatarUpdateSerializer
from rest_framework.views import APIView
from django.contrib.auth import authenticate
from django.conf import settings

redis_client = redis.StrictRedis(host=settings.REDIS_HOST, port=settings.REDIS_PORT, db=settings.REDIS_DB)


class UserViewSet(viewsets.ModelViewSet):
    # handle user register
    authentication_classes = []

    queryset = User.objects.all()
    serializer_class = UserSerializer


class LogoutView(APIView):

    def post(self, request, *args, **kwargs):
        # Assuming the token is passed in the Authorization header
        auth_header = request.headers.get('Authorization')
        if not auth_header or not auth_header.startswith('Bearer '):
            return Response({'error': 'Invalid token'}, status=status.HTTP_400_BAD_REQUEST)

        token = auth_header.split(' ')[1]

        # Retrieve the schema name associated with this token
        schema_name = redis_client.get(token)
        if schema_name:
            # Convert byte response to string
            schema_name = schema_name.decode('utf-8')
            # Delete the in_use flag for the schema
            redis_client.delete(f"{schema_name}_in_use")

        # Delete the schema name associated with this token from Redis
        redis_client.delete(token)

        return Response({'message': 'Logged out successfully'}, status=status.HTTP_200_OK)


class LoginView(APIView):
    authentication_classes = []

    def handle_demo_user(self, timeout):
        # Try to find an available schema
        for schema in settings.DEMO_USER_SCHEMAS:
            in_use = redis_client.get(f"{schema}_in_use")

            # If the schema is not in use, break and use this schema
            if not in_use or in_use.decode('utf-8') == 'False':
                available_schema = schema
                break
        else:  # This will execute if the for loop did not break
            return None

        # Copy from template schema
        restore_schema_to_new_schema(available_schema)

        # Mark this schema as in use
        redis_client.set(f"{available_schema}_in_use", 'True', timeout)
        return available_schema

    def post(self, request, *args, **kwargs):
        username = request.data.get('username')
        password = request.data.get('password')

        if username == 'Demo':
            role = 'demo'
            timeout = 10 * 60  # 10 minutes
            available_schema = self.handle_demo_user(timeout)
            if not available_schema:
                return Response({'error': 'No available demo users. Please try again later'},
                                status=status.HTTP_400_BAD_REQUEST)
            password = settings.DEMO_USER_PWD
            schema_name = available_schema

            # Used for entering data for demo user
            # role = 'normal'
            # timeout = 600 * 60  # 600 minutes
            # schema_name = 'public'
            # password = settings.DEMO_USER_PWD
        else:
            role = 'normal'
            timeout = 600 * 60  # 600 minutes
            schema_name = 'public'

        user_obj = authenticate(request, username=username, password=password)
        if not user_obj:
            return Response({'error': 'Wrong username or password.'}, status=status.HTTP_400_BAD_REQUEST)

        token = create_token({'id': user_obj.id, 'name': user_obj.username, 'role': role}, timeout)

        if role == 'demo':
            redis_client.set(token, schema_name, timeout)

        return Response({'jwt': token})


class RecaptchaView(APIView):
    authentication_classes = []

    def post(self, request, *args, **kwargs):
        r = requests.post(
            'https://www.google.com/recaptcha/api/siteverify',
            data={
                'secret': settings.GOOGLE_KEY,
                'response': request.data['captcha_value'],
            }
        )

        return Response({'captcha': r.json()})


class IsProfileOwner(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        # Only give permissions for the owner of the profile
        return obj.user_id == request.user.get('id')


class AvatarUpdateView(RetrieveUpdateAPIView):
    queryset = Profile.objects.all()
    serializer_class = AvatarUpdateSerializer
    lookup_field = 'user'

    def get_permissions(self):
        if self.request.method == "PUT":
            return [IsProfileOwner()]
        return [AllowAny()]
