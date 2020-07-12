#!/bin/sh

# log.sh - Provides helper function for logging.

log() {
    echo "[$(date -Iseconds)] === $1 ==="
}
