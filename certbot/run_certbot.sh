# see https://certbot.eff.org/docs/using.html#certbot-command-line-options
echo "Running certbot with COMMON_ARGS='$COMMON_ARGS' and LOOP_ARGS='$LOOP_ARGS'"

IFS='|'
for args in $LOOP_ARGS; do
certbot $COMMON_ARGS $args
done
unset IFS
