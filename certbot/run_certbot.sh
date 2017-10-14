#!/usr/bin/env bash
# see https://certbot.eff.org/docs/using.html#certbot-command-line-options

my_dir="$(dirname "$0")"

IFS='|'
for args in $LOOP_ARGS; do
    echo "Running: certbot $COMMON_ARGS $args & deploy-hook-script"
    unset IFS
    certbot --deploy-hook $my_dir/deploy-hook-script.sh $COMMON_ARGS $args
    IFS='|'
done
unset IFS