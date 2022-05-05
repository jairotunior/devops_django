FROM python:3.8
FROM aquasec/trivy:latest as trivy

# cd to directory /usr/src/app. this will be our working directory
WORKDIR /app

COPY ./inventory .

RUN pip install -r requirements.txt --no-cache-dir

COPY --from=trivy /usr/local/bin/trivy /usr/local/bin/trivy
RUN trivy filesystem --exit-code 1 --no-progress --severity HIGH,CRITICAL,MEDIUM /
#RUN trivy rootfs --no-progress /

EXPOSE 8000