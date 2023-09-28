from django.db.models import Count
from rest_framework import status
from rest_framework.generics import GenericAPIView
from rest_framework.mixins import RetrieveModelMixin, DestroyModelMixin
from rest_framework.response import Response
from rest_framework.views import APIView
from datetime import datetime, timedelta
from django.db.models.functions import TruncDate

from api import models
from api.Serializers.stats import StatsProjectSerializer, ModuleSerializer
from api.permissions.permission import IsProjectMember
from api.utils.cos import delete_folder


class StatsProjectView(GenericAPIView, RetrieveModelMixin, DestroyModelMixin):
    queryset = models.Project.objects.all()
    serializer_class = StatsProjectSerializer
    permission_classes = [IsProjectMember]
    lookup_url_kwarg = 'project_id'

    def get(self, request, project_id):
        return self.retrieve(request)

    def delete(self, request, *args, **kwargs):
        project = self.get_object()

        # Check if the project name provided in the request matches
        project_name = request.data.get('project_name')
        if not project_name or project_name != project.name:
            return Response({'error': 'Incorrect project name.'}, status=status.HTTP_400_BAD_REQUEST)

        # Check if the user is the creator of the project
        if request.user.get('id') != project.creator.user_id:
            return Response({'error': 'Only the project creator can delete the project.'},
                            status=status.HTTP_403_FORBIDDEN)

        # Delete the project's associated folder
        folder_name = f"{request.user.get('id')}/{project.id}"
        delete_folder(folder_name)

        # Delete the project
        return self.destroy(request, *args, **kwargs)


class DashboardView(APIView):

    def get(self, request, project_id):

        # Issue number stats
        status_dict = {}
        for key, text in models.Issues.status_choices:
            status_dict[key] = {'text': text, 'count': 0}

        issues_data = models.Issues.objects.filter(project_id=project_id).values('status').annotate(ct=Count('id'))
        for item in issues_data:
            status_dict[item['status']]['count'] = item['ct']

        # Creator
        creator_data = models.Project.objects.filter(id=project_id).values('creator_id',
                                                                           'creator__user__username').first()
        creator_dict = {
            'id': creator_data['creator_id'],
            'username': creator_data['creator__user__username']
        }

        # Joined
        join_data = models.ProjectUser.objects.filter(project_id=project_id).values('user_id', 'user__user__username')
        user_list = [{'id': item['user_id'], 'username': item['user__user__username']} for item in join_data]

        return Response({
            'status_dict': status_dict,
            'creator': creator_dict,
            'user_list': user_list,
        })


class ModuleCreateView(APIView):
    permission_classes = [IsProjectMember]

    def post(self, request, project_id):
        data = request.data
        data['project'] = project_id
        serializer = ModuleSerializer(data=data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class AreaChartView(APIView):
    permission_classes = [IsProjectMember]

    def get(self, request, project_id):
        # Get date 7 days ago from today
        end_date = datetime.now()
        start_date = end_date - timedelta(days=6)

        # Filter Issues in this project that were created within the last 7 days
        # and annotate them by day of creation
        issues = (models.Issues.objects
                  .filter(project_id=project_id, create_datetime__date__range=(start_date, end_date))
                  .annotate(day=TruncDate('create_datetime'))
                  .values('day')
                  .annotate(created_count=Count('id'))
                  .order_by('day'))

        # Prepare data for the chart
        days = [(start_date + timedelta(days=i)).date() for i in range(7)]
        counts = {issue['day']: issue['created_count'] for issue in issues}

        dates = [day.strftime('%A') for day in days]
        data_counts = [counts.get(day, 0) for day in days]

        data = {"dates": dates, "counts": data_counts}

        return Response(data, status=status.HTTP_200_OK)
