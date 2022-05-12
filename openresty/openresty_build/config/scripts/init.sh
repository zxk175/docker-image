RESTY_PREFIX=$1

mysql_log() {
	local type="$1"; shift
	local text="$*"; if [ "$#" -eq 0 ]; then text="$(cat)"; fi
	local dt; dt="$(date "+%Y-%m-%d %H:%M:%S")"
	printf '%s [%s] [Entrypoint]: %s\n' "$dt" "$type" "$text"
}

mysql_note() {
	mysql_log Note "$@"
}

mysql_note "================== $RESTY_PREFIX ================"

# ln -sf /dev/stdout ${RESTY_PREFIX}/nginx/logs/access.log
# ln -sf /dev/stderr ${RESTY_PREFIX}/nginx/logs/error.log
