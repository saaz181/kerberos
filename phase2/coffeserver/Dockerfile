# Dockerfile for CoffeeServer

FROM python:3.10

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y krb5-config libkrb5-dev

RUN pip install flask
RUN pip install flask-gssapi

WORKDIR /app

COPY coffeserver.py /app

CMD ["python3", "coffeserver.py"]
