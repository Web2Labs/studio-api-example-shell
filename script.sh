#!/bin/bash

# Configuration
API_KEY="${SHORTCUT_API_KEY}"
BASE_URL="${SHORTCUT_API_URL:-https://web2labs.com}"
VIDEO_FILE="$1"

# Check dependencies
if ! command -v jq &> /dev/null; then
    echo "Error: 'jq' is required but not installed. Please install it (e.g., brew install jq, apt install jq)."
    exit 1
fi

if [ -z "$API_KEY" ]; then
    echo "Error: SHORTCUT_API_KEY environment variable not set."
    exit 1
fi

if [ -z "$VIDEO_FILE" ]; then
    echo "Usage: ./script.sh <path_to_video_file>"
    exit 1
fi

if [ ! -f "$VIDEO_FILE" ]; then
    echo "Error: File not found at $VIDEO_FILE"
    exit 1
fi

echo "=================================================="
echo "Shortcut API Shell Example"
echo "=================================================="

# 1. Upload Video
echo "1. Uploading $VIDEO_FILE..."
UPLOAD_RESPONSE=$(curl -s -X POST "$BASE_URL/api/v1/projects/upload" \
  -H "X-API-Key: $API_KEY" \
  -F "file=@$VIDEO_FILE" \
  -F "configuration={\"shorts\":true,\"subtitle\":true}")

# Check for curl errors
if [ $? -ne 0 ]; then
    echo "Upload failed: curl error"
    exit 1
fi

# Parse Project ID
PROJECT_ID=$(echo "$UPLOAD_RESPONSE" | jq -r '.data.projectId')
SUCCESS=$(echo "$UPLOAD_RESPONSE" | jq -r '.success')

if [ "$SUCCESS" != "true" ]; then
    echo "Upload failed: $(echo "$UPLOAD_RESPONSE" | jq -r '.error.message')"
    exit 1
fi

echo "Project created: $PROJECT_ID"

# 2. Poll Status
echo "2. Tracking progress..."

while true; do
    STATUS_RESPONSE=$(curl -s -X GET "$BASE_URL/api/v1/projects/$PROJECT_ID/status" \
      -H "X-API-Key: $API_KEY")
    
    STATUS=$(echo "$STATUS_RESPONSE" | jq -r '.data.status')
    STAGE=$(echo "$STATUS_RESPONSE" | jq -r '.data.progress.stage // "Processing"')
    PERCENTAGE=$(echo "$STATUS_RESPONSE" | jq -r '.data.progress.percentage // 0')
    
    # Print status on same line
    printf "\rStatus: %-10s | Stage: %-30s | Progress: %3d%%" "$STATUS" "$STAGE" "$PERCENTAGE"
    
    if [ "$STATUS" == "Completed" ]; then
        echo ""
        echo "Processing completed successfully!"
        break
    elif [ "$STATUS" == "Failed" ]; then
        echo ""
        echo "Processing failed: $(echo "$STATUS_RESPONSE" | jq -r '.data.error.message')"
        exit 1
    fi
    
    sleep 5
done

# 3. Get Results
echo "3. Fetching results..."
RESULTS_RESPONSE=$(curl -s -X GET "$BASE_URL/api/v1/projects/$PROJECT_ID/results" \
  -H "X-API-Key: $API_KEY")

echo ""
echo "=================================================="
echo "RESULTS"
echo "=================================================="

MAIN_VIDEO=$(echo "$RESULTS_RESPONSE" | jq -r '.data.mainVideo.url // empty')
if [ ! -z "$MAIN_VIDEO" ]; then
    echo "Main Video: $MAIN_VIDEO"
fi

echo ""
echo "Shorts:"
echo "$RESULTS_RESPONSE" | jq -r '.data.shorts[] | "- \(.filename): \(.url)"'

SUBTITLES=$(echo "$RESULTS_RESPONSE" | jq -r '.data.subtitles.url // empty')
if [ ! -z "$SUBTITLES" ]; then
    echo ""
    echo "Subtitles: $SUBTITLES"
fi

echo "=================================================="
