#!/usr/bin/env sh
# Railway shim for the official Telegram Bot API server.
#
# Three things Railway needs that the stock entrypoint does not do:
#   1. The listen port must be Railway's injected $PORT, because Railway's HTTP
#      healthcheck and its edge proxy both dial that port. Upstream reads
#      TELEGRAM_HTTP_PORT and defaults to 8081.
#   2. TELEGRAM_API_ID / TELEGRAM_API_HASH are deployer-owned credentials from
#      my.telegram.org. Without them upstream exits with a one-line error deep in
#      the boot sequence; fail early with an explanation instead.
#   3. Local mode is what makes a self-hosted Bot API server worth running at all
#      (2 GB uploads, unlimited downloads, no 20 MB getFile ceiling), so it is on
#      by default and can still be turned off by the deployer.
set -e

if [ -z "${TELEGRAM_API_ID}" ] || [ -z "${TELEGRAM_API_HASH}" ]; then
  echo "[railway] FATAL: TELEGRAM_API_ID and TELEGRAM_API_HASH are required."
  echo "[railway] Create them at https://my.telegram.org -> API development tools,"
  echo "[railway] then set both variables on this service and redeploy."
  exit 1
fi

if [ -n "${PORT}" ]; then
  TELEGRAM_HTTP_PORT="${PORT}"
  export TELEGRAM_HTTP_PORT
fi

echo "[railway] telegram-bot-api http_port=${TELEGRAM_HTTP_PORT:-8081} work_dir=${TELEGRAM_WORK_DIR} local=${TELEGRAM_LOCAL:-<unset>}"

exec /docker-entrypoint.sh "$@"
