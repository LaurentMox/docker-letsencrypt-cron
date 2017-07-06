FROM certbot/certbot
MAINTAINER thanhbv <thanhbv@sandinh.net>

VOLUME /certs

COPY ./certbot/ /certbot
RUN crontab /certbot/crontab && \
    chmod +x /certbot/run_certbot.sh

ENTRYPOINT []
CMD ["crond", "-f", "-d", "1"]
