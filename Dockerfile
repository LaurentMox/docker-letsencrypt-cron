FROM certbot/certbot
MAINTAINER laurentmox

COPY ./certbot/ /certbot
RUN apk update && apk add bash curl
RUN crontab /certbot/crontab && \
    chmod +x /certbot/run_certbot.sh

ENTRYPOINT []
CMD ["crond", "-f", "-d", "1"]
