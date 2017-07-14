FROM certbot/certbot
MAINTAINER laurentmox

VOLUME /certs

COPY ./certbot/ /certbot
RUN apk update && apk add bash
RUN crontab /certbot/crontab && \
    chmod +x /certbot/run_certbot.sh

ENTRYPOINT []
CMD ["crond", "-f", "-d", "1"]
