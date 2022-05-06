FROM aquasec/trivy:0.27.1 AS trivy-image
FROM python:3.8-alpine

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

#RUN adduser -D app-user
#USER app-user

# cd to directory /usr/src/app. this will be our working directory
WORKDIR /app

COPY ./inventory .

#RUN apk add --no-cache --virtual .build-deps gcc linux-headers musl-dev libffi-dev jpeg-dev zlib-dev \
#    && pip install --user -r requirements.txt --no-cache-dir \
#    && apk del .build-deps

RUN set -ex \
    && apk add --no-cache --virtual .build-deps build-base \
    && python -m venv /env \
    && /env/bin/pip install --upgrade pip \
    && /env/bin/pip install -r requirements.txt --no-cache-dir \
    && runDeps="$(scanelf --needed --nobanner --recursive /env \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | sort -u \
        | xargs -r apk info --installed \
        | sort -u)" \
    && apk add --virtual rundeps $runDeps \
    && apk del .build-deps

RUN adduser -D app-user
USER app-user

COPY --from=trivy-image /usr/local/bin/trivy /usr/local/bin/trivy
RUN trivy filesystem --exit-code 1 --no-progress --severity HIGH,CRITICAL,MEDIUM /
#RUN trivy rootfs --no-progress /


EXPOSE 8000