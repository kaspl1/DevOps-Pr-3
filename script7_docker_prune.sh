#!/bin/bash

DATE=$(date +"%Y-%m-%d")
LOG_FILE="container-cleanup-${DATE}.log"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
CONFIRM="${1:---dry-run}"

log_action() {
    echo "[$TIMESTAMP] $1" | tee -a "$LOG_FILE"
}

echo "Searching for stopped containers..."
echo "Stopped Containers Report"
echo "Generated: $TIMESTAMP"

STOPPED=$(docker ps -a --filter "status=exited" --filter "status=created" \
    --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.CreatedAt}}" 2>/dev/null)

if [ -z "$(echo "$STOPPED" | tail -n +2)" ]; then
    log_action "No stopped containers found"
    echo "No stopped containers"
    exit 0
fi

echo "$STOPPED"

if [ "$CONFIRM" != "--force" ]; then
    read -p "Delete all stopped containers? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_action "Operation cancelled by user"
        echo "Cancelled"
        exit 0
    fi
fi

echo "Removing containers..."

docker ps -a --filter "status=exited" --filter "status=created" \
    --format "{{.ID}}" 2>/dev/null | while read CONTAINER_ID; do
    
    CONTAINER_INFO=$(docker inspect --format='{{.Name}}|{{.CreatedAt}}' "$CONTAINER_ID" 2>/dev/null)
    CONTAINER_NAME=$(echo "$CONTAINER_INFO" | cut -d'|' -f1 | sed 's/^\///')
    CREATED_AT=$(echo "$CONTAINER_INFO" | cut -d'|' -f2)
    
    if docker rm "$CONTAINER_ID" >/dev/null 2>&1; then
        log_action "Removed: $CONTAINER_NAME (ID: ${CONTAINER_ID:0:12}) [Created: $CREATED_AT]"
        echo "Removed: $CONTAINER_NAME"
    else
        log_action "Failed to remove: $CONTAINER_ID"
    fi
done

log_action "Cleanup completed"
echo "Done. Log: $LOG_FILE"