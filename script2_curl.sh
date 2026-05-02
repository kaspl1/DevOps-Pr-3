#!/bin/bash

URL="${1:-http://localhost:8080}"
DATE=$(date +"%Y-%m-%d")
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
ERROR_LOG="errors-${DATE}.log"

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "$URL" 2>/dev/null)

if [ "$HTTP_STATUS" -ge 200 ] && [ "$HTTP_STATUS" -lt 400 ]; then
    echo "[$TIMESTAMP] $URL - OK (HTTP $HTTP_STATUS)"
else
    echo "[$TIMESTAMP] $URL - FAIL (HTTP ${HTTP_STATUS:-CONNECTION_ERROR})" | tee -a "$ERROR_LOG"
    echo "Error: $(curl -s --connect-timeout 5 "$URL" 2>&1 | head -n 1)" >> "$ERROR_LOG"
    exit 1
fi