FROM aquasec/trivy:0.27.1 AS trivy-image
FROM python:3.8

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN useradd -u 1234 app-user

# cd to directory /usr/src/app. this will be our working directory
WORKDIR /app

COPY ./inventory .

RUN pip install -r requirements.txt --no-cache-dir

COPY --from=trivy-image /usr/local/bin/trivy /usr/local/bin/trivy
#RUN trivy filesystem --exit-code 1 --no-progress --severity HIGH,CRITICAL,MEDIUM /
RUN trivy rootfs --no-progress /

USER app-user

EXPOSE 8000