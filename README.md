# docker-letsencrypt-cron
Create and automatically renew website SSL certificates using the letsencrypt free certificate authority, and its client *certbot*.

This image will renew your certificates every 2 months.

# Usage

## Setup

In docker-compose.yml, change the environment variables:
- COMMON_ARGS: those arguments will be passed to each call of certbot command
- LOOP_ARGS: a `|` separated list of arguments list. Each list will be passed to a separated certbot command.

## Running

### Using the automated image

```shell
docker run --name certbot -d --restart=unless-stopped \
    -v /etc/letsencrypt:/etc/letsencrypt \
    -v /var/lib/letsencrypt:/var/lib/letsencrypt \
    -v /var/www/domain1:/var/www/domain1 \
    -v /var/www/domain2:/var/www/domain2 \
    -e COMMON_ARGS="certonly --agree-tos --non-interactive --keep-until-expiring --email webmaster@domain1.com --webroot" \
    -e LOOP_ARGS="-w /var/www/domain1 -d domain1.com,www.domain1.com,domain1.net | -w /var/www/domain2 -d domain2.com,www.domain2.com" \
    sandinh/certbot-cron
```

### Building the image

The easiest way to build the image yourself is to use the provided docker-compose file.

```shell
docker-compose up -d
```

The first time you start it up, you may want to run the certificate generation script immediately:

```shell
docker exec certbot ash -c "/certbot/run_certbot.sh"
```

At 3AM, on the 1st of every odd month, a cron job will start the script, renewing your certificates.

# ACME Validation challenge

To authenticate the certificates, the you need to pass the ACME validation challenge. This requires requests made on port 80 to your.domain.com/.well-known/ to be forwarded to this container.

The recommended way to use this image is to set up your reverse proxy to automatically forward requests for the ACME validation challenges to this container.

## Haproxy example

If you use a haproxy reverse proxy, you can add the following to your configuration file in order to pass the ACME challenge.

``` haproxy
frontend http
  bind *:80
  acl letsencrypt_check path_beg /.well-known

  use_backend certbot if letsencrypt_check

backend certbot
  server certbot certbot:80 maxconn 32
```

## Nginx example

If you use nginx as a reverse proxy, you can add the following to your configuration file in order to pass the ACME challenge.

``` nginx
upstream certbot_upstream{
  server certbot:80;
}

server {
  listen              80;
  location '/.well-known/acme-challenge' {
    default_type "text/plain";
    proxy_pass http://certbot_upstream;
  }
}

```

# More information

Find out more about letsencrypt: https://letsencrypt.org

Certbot github: https://github.com/certbot/certbot

# Changelog

### 0.3
- Add support for webroot mode.
- Run certbot once with all domains.

### 0.2
- Upgraded to use certbot client
- Changed image to use alpine linux

### 0.1
- Initial release
