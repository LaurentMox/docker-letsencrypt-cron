# see https://certbot.eff.org/docs/using.html#certbot-command-line-options

IFS='|'
for args in $LOOP_ARGS; do
echo "Running: certbot $COMMON_ARGS $args"
unset IFS
certbot $COMMON_ARGS $args
IFS='|'
done
unset IFS
