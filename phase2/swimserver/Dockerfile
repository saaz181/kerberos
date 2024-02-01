# Dockerfile for SwimServer

FROM python:3.10

# Install system dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y krb5-config libkrb5-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install flask flask-gssapi

# Set the working directory
WORKDIR /app/

# Copy the application code
COPY /swimserver.py /app/

# Command to run the application
CMD ["python3", "swimserver.py"]
