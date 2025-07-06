#!/bin/sh

export NODE_ENV="${NODE_ENV:-production}"
export SITE_URL="${SITE_URL:-http://localhost:8080}"
export UI_PORT="${UI_PORT:-3000}"
export UI_HOST="${UI_HOST:-127.0.0.1}"
export API_PORT="${API_PORT:-8080}"
export API_HOST="${API_HOST:-127.0.0.1}"
export MONGODB_URL="${MONGODB_URL:-mongodb://localhost:27017/learninglocker_v2}"
export MONGODB_TEST_URL="${MONGODB_TEST_URL:-mongodb://localhost:27017/llv2tests}"
export REDIS_URL="${REDIS_URL:-redis://127.0.0.1:6379/0}"
export REDIS_PREFIX="${REDIS_PREFIX:-LEARNINGLOCKER}"
export LOG_MIN_LEVEL="${LOG_MIN_LEVEL:-info}"
export GOOGLE_ENABLED="${GOOGLE_ENABLED:-false}"
export QUEUE_PROVIDER="${QUEUE_PROVIDER:-REDIS}"
export QUEUE_NAMESPACE="${QUEUE_NAMESPACE:-DEV}"
export FS_REPO="${FS_REPO:-local}"

envsubst < /app/env.template > /app/.env

exec "$@"