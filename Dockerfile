FROM aquasec/trivy:0.27.1 AS trivy-image
FROM alpine:latest

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN adduser -D app-user
USER app-user

# cd to directory /usr/src/app. this will be our working directory
WORKDIR /app

COPY ./inventory .

RUN apk add --no-cache --update python3-dev gcc build-base

RUN pip install --user -r requirements.txt --no-cache-dir

COPY --from=trivy-image /usr/local/bin/trivy /usr/local/bin/trivy
RUN trivy filesystem --exit-code 1 --no-progress --severity HIGH,CRITICAL,MEDIUM /
#RUN trivy rootfs --no-progress /


EXPOSE 8000