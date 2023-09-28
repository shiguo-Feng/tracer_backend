from api.scripts import base
from api import models


def run():
    exits = models.PricePolicy.objects.filter(category=1, title='Free').exists()
    if not exits:
        models.PricePolicy.objects.create(
            title='Free',
            price=0,
            project_num=3,
            project_member=2,
            project_space=5,
            per_file_size=5,
            category=1
        )


if __name__ == "__main__":
    run()