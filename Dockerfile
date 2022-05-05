FROM python:3.8

RUN useradd -u 1234 app-user
USER app-user

# cd to directory /usr/src/app. this will be our working directory
WORKDIR /app

COPY ./inventory .

RUN pip install -r requirements.txt --no-cache-dir

FROM aquasec/trivy:0.27.1 AS trivy-image

COPY --from=trivy-image /usr/local/bin/trivy /usr/local/bin/trivy
RUN trivy filesystem --exit-code 1 --no-progress --severity HIGH,CRITICAL,MEDIUM /
#RUN trivy rootfs --no-progress /

EXPOSE 8000