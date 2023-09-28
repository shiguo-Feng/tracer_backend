# Use the official Python 3.8 image as the base image
FROM python:3.8-slim

# Set the working directory to /app
# This directory will be created in the container if it doesn't exist
WORKDIR /app

# Set environment variable to ensure Python output is sent directly to terminal without buffering
ENV PYTHONUNBUFFERED=1

# Copy the requirements.txt file to the container's /app directory
# This file lists all the Python packages that the application depends on
COPY requirements.txt /app/

# Install the dependencies listed in requirements.txt in the container
# The --no-cache-dir flag is used to prevent the Docker image from storing the cache of pip packages
# This can help to reduce the image size
RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get update && apt-get install -y postgresql-client

# Copy all files and directories from the host to the container's /app directory
# This will include all Django project files
COPY . /app/

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
