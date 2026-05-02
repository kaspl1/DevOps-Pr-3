#!/bin/bash

CONTAINER_NAME="${1:?Usage: $0 <container_name>}"
DATE=$(date +"%Y-%m-%d")
LOG_FILE="container-status-${DATE}.log"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

log_msg() {
    echo "[$TIMESTAMP] $1" | tee -a "$LOG_FILE"
}

if ! docker ps -a --format "{{.Names}}" | grep -qx "$CONTAINER_NAME"; then
    log_msg "Error: Container '$CONTAINER_NAME' not found"
    exit 1
fi

if docker ps --format "{{.Names}}" | grep -qx "$CONTAINER_NAME"; then
    STATUS=$(docker ps --filter "name=$CONTAINER_NAME" --format "{{.Status}}")
    STARTED=$(docker inspect --format='{{.State.StartedAt}}' "$CONTAINER_NAME" 2>/dev/null)
    log_msg "Container '$CONTAINER_NAME' is running"
    log_msg "Status: $STATUS"
    log_msg "Started: $STARTED"
else
    log_msg "Container '$CONTAINER_NAME' is stopped. Starting..."
    if docker start "$CONTAINER_NAME" >/dev/null 2>&1; then
        log_msg "Container '$CONTAINER_NAME' started successfully"
    else
        log_msg "Error: Failed to start container '$CONTAINER_NAME'"
        exit 1
    fi
fi