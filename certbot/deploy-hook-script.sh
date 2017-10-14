#!/bin/sh

my_dir="$(dirname "$0")"
source "$my_dir/functions.sh"

set -e

for domain in $RENEWED_DOMAINS; do
        cert_root="/certs/$domain/"
        mkdir -p $cert_root

        # Make sure the certificate and private key files are
        # never world readable, even just for an instant while
        # we're copying them into cert_root.
        umask 077

        cp "$RENEWED_LINEAGE/fullchain.pem" "$cert_root/fullchain.pem"
        cp "$RENEWED_LINEAGE/privkey.pem" "$cert_root/privkey.pem"
done

docker_kill "$NGINX_PROXY_CONTAINER" SIGHUP