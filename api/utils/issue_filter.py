from django_filters import rest_framework as filters, BaseInFilter, NumberFilter, CharFilter, OrderingFilter
from api import models


class NumberInFilter(BaseInFilter, NumberFilter):
    """
    A custom filter class that allows filtering by multiple numerical values in a single query parameter.
    For example, ?issues_type=1,2,3.
    """
    pass


class CharInFilter(BaseInFilter, CharFilter):
    """
    A custom filter class that allows filtering by multiple string values in a single query parameter.
    For example, ?priority=high,medium,low.
    """
    pass


class IssuesFilter(filters.FilterSet):
    # Define filters for different fields of the Issues model.
    issues_type = NumberInFilter(field_name="issues_type", lookup_expr='in')
    status = NumberInFilter(field_name="status", lookup_expr='in')
    priority = CharInFilter(field_name="priority", lookup_expr='in')
    assign = NumberInFilter(field_name="assign", lookup_expr='in')
    attention = NumberInFilter(field_name="attention", lookup_expr='in')

    # Define ordering filter to allow ordering by 'latest_update_datetime' and 'project_issue_id'.
    order_by = OrderingFilter(
        fields=(
            ('latest_update_datetime', 'latest_update'),
            ('project_issue_id', 'issue_id'),
        ),
        field_labels={
            'latest_update_datetime': 'Latest Update Time',
            'project_issue_id': 'Issue ID Based On Project',
        }
    )

    class Meta:
        model = models.Issues
        fields = ['issues_type', 'status', 'priority', 'assign', 'attention', 'order_by']
