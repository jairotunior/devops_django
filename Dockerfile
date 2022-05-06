FROM aquasec/trivy:0.27.1 AS trivy-image
FROM python:3.8-alpine

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

#RUN adduser -D app-user
#USER app-user

# cd to directory /usr/src/app. this will be our working directory
WORKDIR /app

COPY ./inventory .

RUN apk add --no-cache --virtual .build-deps gcc linux-headers musl-dev libffi-dev jpeg-dev zlib-dev

RUN pip install --user -r requirements.txt --no-cache-dir

RUN adduser -D app-user
USER app-user

COPY --from=trivy-image /usr/local/bin/trivy /usr/local/bin/trivy
RUN trivy filesystem --exit-code 1 --no-progress --severity HIGH,CRITICAL,MEDIUM /
#RUN trivy rootfs --no-progress /


EXPOSE 8000