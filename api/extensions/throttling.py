from rest_framework.throttling import SimpleRateThrottle


class CustomRateThrottle(SimpleRateThrottle):
    rate = '150/minute'

    def get_cache_key(self, request, view):
        # Using the user ID from the JWT payload as the unique identifier for throttling
        if isinstance(request.user, dict):
            user_id = request.user.get('id')
            if user_id:
                return self.cache_format % {
                    'scope': self.scope,
                    'ident': user_id
                }
        # No throttle for requests without authentication or for Anonymous users
        return None
