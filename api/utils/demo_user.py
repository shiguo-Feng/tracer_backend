import subprocess
from django.conf import settings


def restore_schema_to_new_schema(new_schema_name):
    # Database connection parameters
    db_params = [
        '-q',
        '-U', settings.DATABASES['default']['USER'],
        '-h', settings.DATABASES['default']['HOST'],
        '-p', settings.DATABASES['default']['PORT'],
        settings.DATABASES['default']['NAME']
    ]

    # Drop existing schema
    drop_schema_cmd = ['psql'] + db_params + ['-c', f'DROP SCHEMA IF EXISTS {new_schema_name} CASCADE']
    try:
        subprocess.check_output(drop_schema_cmd, stderr=subprocess.PIPE)
    except subprocess.CalledProcessError as e:
        raise Exception(f"Error occurred while dropping the schema: {e.output.decode()}")

    # Replace schema name in SQL and restore
    sed_cmd = ['sed', 's/public/{}/g'.format(new_schema_name), 'schema_dump.sql']
    psql_cmd = ['psql'] + db_params
    sed_process = subprocess.Popen(sed_cmd, stdout=subprocess.PIPE)
    psql_process = subprocess.Popen(psql_cmd, stdin=sed_process.stdout, stderr=subprocess.PIPE)
    sed_process.stdout.close()
    _, stderr = psql_process.communicate()
    if psql_process.returncode != 0:
        raise Exception(f"Error occurred while executing the SQL script: {stderr.decode()}")

    print(f"Schema {new_schema_name} restored successfully!")

