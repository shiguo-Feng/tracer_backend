import redis
from django.db import connection
from rest_framework.authentication import BaseAuthentication
from rest_framework.exceptions import AuthenticationFailed
import jwt
from jwt import InvalidTokenError, ExpiredSignatureError
from django.conf import settings

redis_client = redis.StrictRedis(host=settings.REDIS_HOST, port=settings.REDIS_PORT, db=settings.REDIS_DB)


class JwtAuthentication(BaseAuthentication):
    def set_search_path(self, user_role, token):

        """Set the PostgreSQL search path based on the user role."""
        if user_role == "demo":
            # For demo users, set the search path to their specific schema
            schema_name = redis_client.get(token).decode('utf-8')

            with connection.cursor() as cursor:
                cursor.execute("SET search_path TO %s", [schema_name])
        else:
            # For other users, set the search path to public
            with connection.cursor() as cursor:
                cursor.execute("SET search_path TO public")

    def authenticate(self, request):
        auth_header = request.META.get('HTTP_AUTHORIZATION')
        salt = settings.SECRET_KEY

        # Ensure the auth_header exists
        if not auth_header:
            raise AuthenticationFailed('Please Login First')

        # Ensure the auth_header starts with 'Bearer'
        if not auth_header.startswith('Bearer '):
            raise AuthenticationFailed('Invalid authorization header format')

        try:
            token = auth_header.split(' ')[1]  # split on space and get the second element
            payload = jwt.decode(token, salt, algorithms=['HS256'])
        except ExpiredSignatureError:
            # token expired
            raise AuthenticationFailed('Token expired')
        except InvalidTokenError:
            # invalid token
            raise AuthenticationFailed('Invalid token')
        except Exception:
            raise AuthenticationFailed('Error decoding the token')

        self.set_search_path(payload.get("role"), token)

        # If the token is valid and has not expired, return the payload and token
        return (payload, token)
