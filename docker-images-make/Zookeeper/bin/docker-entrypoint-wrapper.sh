#!/bin/bash

set -e

if [[ ! -d "$ZOO_DATA_DIR" ]]; then
  mkdir -p "$ZOO_DATA_DIR"
fi

if [[ ! -d "$ZOO_DATA_LOG_DIR" ]]; then
  mkdir -p "$ZOO_DATA_LOG_DIR"
fi

if [[ ! -d "$ZOO_LOG_DIR" ]]; then
  mkdir -p "$ZOO_LOG_DIR"
fi

exec /docker-entrypoint.sh "$@"
