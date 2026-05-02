#!/bin/bash

DATE=$(date +"%Y-%m-%d")
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
OUTPUT_FILE="docker-images-sizes-${DATE}.txt"

{
    echo "Docker Images Size Report"
    echo "Generated: $TIMESTAMP"
    echo "--------------------------------"
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.ID}}"
    
    echo ""
    echo "Largest image:"
    docker images --format "{{.Repository}}:{{.Tag}}\t{{.Size}}\t{{.SizeBytes}}" | \
        sort -k3 -rn | head -n 1 | cut -f1-2
} > "$OUTPUT_FILE" 2>&1

echo "Report saved to $OUTPUT_FILE"