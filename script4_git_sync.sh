#!/bin/bash

REPO_PATH="${1:-.}"
LOG_FILE="git-sync.log"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

[ ! -d "$REPO_PATH/.git" ] && echo "[$TIMESTAMP] Error: $REPO_PATH is not a git repository" | tee -a "$LOG_FILE" && exit 1

cd "$REPO_PATH" || exit 1

{
    echo "=== Git Sync Log ==="
    echo "Time: $TIMESTAMP"
    echo "Repository: $(pwd)"
    echo "-------------------"
    echo "Executing git pull..."
    git pull --ff-only 2>&1
    echo ""
    echo "Last commit:"
    git log -1 --format="Author: %an <%ae>%nDate: %ad%nMessage: %s" --date=short
} | tee -a "$LOG_FILE"