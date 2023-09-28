import uuid
from datetime import datetime

import qiniu.config
from django.conf import settings
from qiniu import Auth, put_data, etag, put_file, BucketManager, build_batch_delete


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


def upload_cos(request, obj ,project_id):
    # 需要填写你的 Access Key 和 Secret Key
    access_key = settings.QINIU_ACCESS_KEY
    secret_key = settings.QINIU_SECRET_KEY
    # 构建鉴权对象
    q = Auth(access_key, secret_key)
    # 要上传的空间
    bucket_name = settings.BUCKET_NAME
    # 上传后保存的文件名
    filepath = object_upload_path(request, obj, project_id)
    key = filepath
    # 生成上传 Token，可以指定过期时间等
    token = q.upload_token(bucket_name, key, 3600)
    # 要上传文件的本地路径
    localfile = obj
    ret, info = put_data(token, key, localfile)
    # print(info)
    # "http://rxpq2pufp.bkt.gdipper.com/lambert/2023/12/01/my-python-logo.png"
    return "{}/{}".format(settings.QINIU_DOMAIN, filepath)


def check_file(file_key):
    access_key = settings.QINIU_ACCESS_KEY
    secret_key = settings.QINIU_SECRET_KEY
    q = Auth(access_key, secret_key)
    bucket = BucketManager(q)

    # 设置你的七牛云存储空间名和文件名
    bucket_name = settings.BUCKET_NAME
    key = file_key

    # 调用stat方法来获取文件的信息
    ret, info = bucket.stat(bucket_name, key)
    # print(info)

    # 从文件信息中获取ETag字段的值
    # etag = ret['hash']
    return ret


def gen_upload_token(request):
    # 需要填写你的 Access Key 和 Secret Key
    access_key = settings.QINIU_ACCESS_KEY
    secret_key = settings.QINIU_SECRET_KEY
    # 构建鉴权对象
    q = Auth(access_key, secret_key)
    # 要上传的空间
    bucket_name = settings.BUCKET_NAME
    # 生成上传凭证
    upload_token = q.upload_token(bucket=bucket_name)
    # 返回上传凭证
    return upload_token

def delete_file(file_key):
    access_key = settings.QINIU_ACCESS_KEY
    secret_key = settings.QINIU_SECRET_KEY
    # 初始化Auth状态
    q = Auth(access_key, secret_key)
    # 初始化BucketManager
    bucket = BucketManager(q)
    # 你要测试的空间， 并且这个key在你空间中存在
    bucket_name = settings.BUCKET_NAME
    key = file_key
    # 删除bucket_name 中的文件 key
    ret, info = bucket.delete(bucket_name, key)
    print(info)
    # assert ret == {}

def delete_file_batch(key_list):
    access_key = settings.QINIU_ACCESS_KEY
    secret_key = settings.QINIU_SECRET_KEY
    q = Auth(access_key, secret_key)
    bucket = BucketManager(q)
    bucket_name = settings.BUCKET_NAME
    # keys = ['1.gif', '2.txt', '3.png', '4.html']
    keys = key_list
    ops = build_batch_delete(bucket_name, keys)
    ret, info = bucket.batch(ops)
    print(info)


def delete_folder(folder_name):
    access_key = settings.QINIU_ACCESS_KEY
    secret_key = settings.QINIU_SECRET_KEY

    # 初始化Auth状态
    q = Auth(access_key, secret_key)

    # 初始化BucketManager
    bucket = BucketManager(q)

    # 您要操作的空间
    bucket_name = settings.BUCKET_NAME

    # 要删除的文件夹名称，需要以 "/" 结尾
    folder_name = '{}/'.format(folder_name)

    # 列举文件夹下的所有文件
    ret, eof, _ = bucket.list(bucket_name, prefix=folder_name)
    print(ret)

    if ret is not None:
        # 构建批量删除请求
        ops = build_batch_delete(bucket_name, [item['key'] for item in ret['items']])

        # 执行批量删除请求
        ret, info = bucket.batch(ops)
    else:
        print('Error listing files in folder')