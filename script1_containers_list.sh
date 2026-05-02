#!/bin/bash

DATE=$(date +"%Y-%m-%d")
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
OUTPUT_FILE="containers-${DATE}.txt"

{
    echo "Docker Containers Report"
    echo "Generated: $TIMESTAMP"
    echo "--------------------------------"
    docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
} > "$OUTPUT_FILE" 2>&1

[ $? -eq 0 ] && echo "Saved to $OUTPUT_FILE" || exit 1