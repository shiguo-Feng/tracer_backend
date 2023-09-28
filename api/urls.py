from django.urls import path, include
# from api.Views.views_function_based import Index, #article_list, article_details
# from .Views import ArticleList, ArticleDetails
from rest_framework.routers import DefaultRouter, SimpleRouter
from api.Views.account import UserViewSet, LoginView, RecaptchaView, AvatarUpdateView, LogoutView
from api.Views.project import ProjectView, ProjectDetailView, JoinedProjectStarView
from api.Views.wiki import WikiView, WikiDetailView, WikiCatalogView, WikiUploadView
from api.Views.file import FolderView, FolderDetailView,FileDetailView, COSCredentialView, FilePostView
from api.Views.issues import IssuesChoicesView, IssuesView, IssueDetailView, IssueReplyView, ProjectInviteView, \
    ProjectJoinView
from api.Views.stats import StatsProjectView, DashboardView, ModuleCreateView, AreaChartView

router = DefaultRouter()

auth_router = SimpleRouter()
auth_router.register('users', UserViewSet)

urlpatterns = [
    path('api/', include(router.urls)),

    # account
    path('api/auth/', include(auth_router.urls)),
    path('api/login/', LoginView.as_view()),
    path('api/recaptcha/', RecaptchaView.as_view()),
    path('api/logout/', LogoutView.as_view()),

    # project
    path('api/projects/', ProjectView.as_view(), name='project-list'),
    path('api/my-projects/<int:pk>/star/', ProjectDetailView.as_view(), name='project-star'),
    path('api/joined-projects/<int:project_id>/star/', JoinedProjectStarView.as_view(), name='joined_project-star'),

    # profile
    path('api/profile/<int:user>/avatar/', AvatarUpdateView.as_view(), name='avatar-update'),

    path('api/manage/<int:project_id>/', include([
        # wiki
        path('wiki/', WikiView.as_view(), name='wiki'),
        path('wiki/<int:pk>/', WikiDetailView.as_view(), name='wiki-detail'),
        path('wiki/catalog/', WikiCatalogView.as_view(), name='wiki_catalog'),
        path('wiki/upload/', WikiUploadView.as_view(), name='wiki_upload'),

        # file
        path('file/', FolderView.as_view(), name='file_folder'),
        path('file/folder/<int:folder_id>/', FolderDetailView.as_view(), name='file_folder_detail'),
        path('file/file/', FilePostView.as_view(), name='file_view'),
        path('file/file/<int:file_id>/', FileDetailView.as_view(), name='file_folder_detail'),
        path('file/cos/', COSCredentialView.as_view(), name='file_cos'),

        # Issues
        path('issues/choices/', IssuesChoicesView.as_view(), name='form_choices'), # For new issues
        path('issues/choices/<int:issues_id>/', IssuesChoicesView.as_view(), name='form_choices_for_edit'), # For editing an existing issue
        path('issues/', IssuesView.as_view(), name='issues'),
        path('issues/<int:pk>/', IssueDetailView.as_view(), name='issues_details'),
        path('issues/record/<int:issues_id>/', IssueReplyView.as_view(), name='issues_record'),
        path('issues/invite/', ProjectInviteView.as_view(), name='issues_invite'),

        # Stats
        path('stats/project_detail/', StatsProjectView.as_view(), name='stats_project'),
        path('stats/', DashboardView.as_view(), name='stats_dashboard'),
        path('stats/module/', ModuleCreateView.as_view(), name='add_module'),
        path('stats/trend/',AreaChartView.as_view(), name='issues_trend')
    ])),
    path('api/join/<str:code>/', ProjectJoinView.as_view(), name='invite_join')
]
