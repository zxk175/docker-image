RESTY_PREFIX=$1

ln -sf /dev/stdout ${RESTY_PREFIX}/nginx/logs/access.log
ln -sf /dev/stderr ${RESTY_PREFIX}/nginx/logs/error.log
