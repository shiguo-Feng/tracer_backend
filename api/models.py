from django.db import models
from django.contrib.auth.models import User


# Create your models here.

class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True)
    price_policy = models.ForeignKey(to='PricePolicy', on_delete=models.SET_NULL, null=True, default=1)
    avatar = models.SmallIntegerField(default=1)


class PricePolicy(models.Model):
    category_choices = (
        (1, 'Free'),
        (2, 'VIP'),
        (3, 'Other'),
    )
    category = models.SmallIntegerField(verbose_name='Category', default=1, choices=category_choices)
    title = models.CharField(verbose_name='title', max_length=32)
    price = models.PositiveIntegerField(verbose_name='price')

    project_num = models.PositiveIntegerField(verbose_name='project_num')
    project_member = models.PositiveIntegerField(verbose_name='project_member_num')
    project_space = models.PositiveIntegerField(verbose_name='project_space', help_text='M')
    per_file_size = models.PositiveIntegerField(verbose_name='per_file_size', help_text="M")

    create_datetime = models.DateTimeField(verbose_name='create_datetime', auto_now_add=True)


class Project(models.Model):
    """ Project table """
    COLOR_CHOICES = (
        (1, "#56b8eb"),  # 56b8eb
        (2, "#f28033"),  # f28033
        (3, "#ebc656"),  # ebc656
        (4, "#a2d148"),  # a2d148
        (5, "#20BFA4"),  # #20BFA4
        (6, "#7461c2"),  # 7461c2
        (7, "#20bfa3"),  # 20bfa3
    )

    name = models.CharField(verbose_name='Project name', max_length=32)
    color = models.SmallIntegerField(verbose_name='Color', choices=COLOR_CHOICES, default=1)
    desc = models.CharField(verbose_name='Project description', max_length=255, null=True, blank=True)

    use_space = models.BigIntegerField(verbose_name='Used space of the project', default=0, help_text='Bytes')

    star = models.BooleanField(verbose_name='Star', default=False)

    join_count = models.SmallIntegerField(verbose_name='Number of participants', default=1)
    creator = models.ForeignKey(verbose_name='Creator', to='Profile', on_delete=models.CASCADE)
    create_datetime = models.DateTimeField(verbose_name='Creation time', auto_now_add=True)

    next_issue_id = models.PositiveIntegerField(default=1)


class ProjectUser(models.Model):
    """ Project participant """
    project = models.ForeignKey(verbose_name='Project', to='Project', on_delete=models.CASCADE)
    user = models.ForeignKey(verbose_name='Participant', to='Profile', on_delete=models.CASCADE)
    star = models.BooleanField(verbose_name='Star', default=False)

    create_datetime = models.DateTimeField(verbose_name='Joining time', auto_now_add=True)


class Wiki(models.Model):
    project = models.ForeignKey(verbose_name='Project', to='Project', on_delete=models.CASCADE)
    title = models.CharField(verbose_name='Title', max_length=32)
    content = models.TextField(verbose_name='Content')

    depth = models.IntegerField(verbose_name='Depth', default=1)

    # Child relation
    parent = models.ForeignKey(verbose_name='Parent article', to="Wiki", null=True, blank=True, related_name='children',
                               on_delete=models.CASCADE)

    def __str__(self):
        return self.title


class FileRepository(models.Model):
    """ File repository """

    class Meta:
        unique_together = ('name', 'project', 'parent')

    project = models.ForeignKey(verbose_name='Project', to='Project', on_delete=models.CASCADE)
    file_type_choices = (
        (1, 'File'),
        (2, 'Folder')
    )
    file_type = models.SmallIntegerField(verbose_name='Type', choices=file_type_choices)
    name = models.CharField(verbose_name='Folder name', max_length=32, help_text="File/Folder name")
    key = models.CharField(verbose_name='File storage KEY in COS', max_length=128, null=True, blank=True)

    # Maximum data represented by int type
    file_size = models.BigIntegerField(verbose_name='File size', null=True, blank=True, help_text='Bytes')

    file_path = models.CharField(verbose_name='File path', max_length=255, null=True,
                                 blank=True)

    parent = models.ForeignKey(verbose_name='Parent directory', to='self', related_name='child', null=True, blank=True,
                               on_delete=models.CASCADE)

    update_user = models.ForeignKey(verbose_name='Last updater', to='Profile', on_delete=models.CASCADE)
    update_datetime = models.DateTimeField(verbose_name='Update time', auto_now=True)


class Issues(models.Model):
    """ Issue """
    project = models.ForeignKey(verbose_name='Project', to='Project', on_delete=models.CASCADE)
    project_issue_id = models.PositiveIntegerField()

    def save(self, *args, **kwargs):
        if not self.project_issue_id:
            self.project_issue_id = self.project.next_issue_id
            self.project.next_issue_id += 1
            self.project.save(update_fields=['next_issue_id'])
        super().save(*args, **kwargs)

    issues_type = models.ForeignKey(verbose_name='Issue Type', to='IssuesType', on_delete=models.CASCADE)
    module = models.ForeignKey(verbose_name='Module', to='Module', null=True, blank=True, on_delete=models.CASCADE)

    subject = models.CharField(verbose_name='Subject', max_length=80)
    desc = models.TextField(verbose_name='Description')
    priority_choices = (
        ("error", "High"),
        ("warning", "Medium"),
        ("success", "Low"),
    )
    priority = models.CharField(verbose_name='Priority', max_length=12, choices=priority_choices, default='error')

    # New, In Progress, Resolved, Ignored, Awaiting Feedback, Closed, Reopened
    status_choices = (
        (1, 'New'),
        (2, 'In Progress'),
        (3, 'Resolved'),
        (4, 'Ignored'),
        (5, 'Awaiting Feedback'),
        (6, 'Closed'),
        (7, 'Reopened'),
    )
    status = models.SmallIntegerField(verbose_name='Status', choices=status_choices, default=1)

    assign = models.ForeignKey(verbose_name='Assigned To', to='Profile', related_name='task', null=True, blank=True,
                               on_delete=models.CASCADE)
    attention = models.ManyToManyField(verbose_name='Watchers', to='Profile', related_name='observe', blank=True)

    start_date = models.DateTimeField(verbose_name='Start Date', null=True, blank=True)
    end_date = models.DateTimeField(verbose_name='End Date', null=True, blank=True)
    mode_choices = (
        (1, 'Public'),
        (2, 'Private'),
    )
    mode = models.SmallIntegerField(verbose_name='Mode', choices=mode_choices, default=1)

    parent = models.ForeignKey(verbose_name='Parent Issue', to='self', related_name='child', null=True, blank=True,
                               on_delete=models.SET_NULL)

    creator = models.ForeignKey(verbose_name='Creator', to='Profile', related_name='create_problems',
                                on_delete=models.CASCADE)

    create_datetime = models.DateTimeField(verbose_name='Creation Date', auto_now_add=True)
    latest_update_datetime = models.DateTimeField(verbose_name='Last Update Date', auto_now=True)

    def __str__(self):
        return self.subject


class Module(models.Model):
    """ Module (Milestone) """
    project = models.ForeignKey(verbose_name='Project', to='Project', on_delete=models.CASCADE)
    title = models.CharField(verbose_name='Module name', max_length=32)

    def __str__(self):
        return self.title


class IssuesType(models.Model):
    """ Issue Type e.g.: Task, Feature, Bug """

    PROJECT_INIT_LIST = ["Task", 'Feature', 'Bug']

    title = models.CharField(max_length=32)
    project = models.ForeignKey(to='Project', on_delete=models.CASCADE)

    def __str__(self):
        return self.title


class IssuesReply(models.Model):
    """ Issue Reply """

    REPLY_TYPE_CHOICES = (
        (1, 'Log'),
        (2, 'Reply')
    )

    reply_type = models.IntegerField(choices=REPLY_TYPE_CHOICES)
    issues = models.ForeignKey(to='Issues', on_delete=models.CASCADE)
    content = models.TextField()
    creator = models.ForeignKey(to='Profile', related_name='create_reply', on_delete=models.CASCADE)
    create_datetime = models.DateTimeField(auto_now_add=True)
    reply = models.ForeignKey(to='self', null=True, blank=True, on_delete=models.CASCADE)


class ProjectInvite(models.Model):
    """ Project Invitation Code """
    project = models.ForeignKey(verbose_name='Project', to='Project', on_delete=models.CASCADE)
    code = models.CharField(verbose_name='Invitation Code', max_length=64, unique=True)
    count = models.PositiveIntegerField(verbose_name='Limit Quantity', null=True, blank=True,
                                        help_text='Empty means no quantity limit')
    use_count = models.PositiveIntegerField(verbose_name='Invited Quantity', default=0)
    period_choices = (
        (30, '30 minutes'),
        (60, '1 hour'),
        (300, '5 hours'),
        (1440, '24 hours'),
    )
    period = models.IntegerField(verbose_name='Validity Period', choices=period_choices, default=1440)
    create_datetime = models.DateTimeField(verbose_name='Creation Time', auto_now_add=True)
    creator = models.ForeignKey(verbose_name='Creator', to='Profile', related_name='create_invite',
                                on_delete=models.CASCADE)