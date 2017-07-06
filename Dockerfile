FROM python:2-alpine
MAINTAINER Henri Dwyer <henri@dwyer.io>

VOLUME /certs
VOLUME /etc/letsencrypt
EXPOSE 80

RUN apk add --no-cache --virtual .build-deps linux-headers gcc musl-dev\
  && apk add --no-cache libffi-dev openssl-dev dialog\
  && pip install certbot\
  && apk del .build-deps\
  && mkdir /scripts

COPY ./certbot/ /certbot
RUN crontab /certbot/crontab && \
    chmod +x /certbot/run_certbot.sh

ENTRYPOINT []
CMD ["crond", "-f"]
