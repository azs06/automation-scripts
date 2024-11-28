#!/bin/bash

# Prompt user for remote server details
read -p "Enter remote server (e.g., user@hostname): " REMOTE_SERVER
read -p "Enter remote folder path (absolute path): " REMOTE_FOLDER
read -p "Enter local destination folder path: " LOCAL_DESTINATION

# Ensure the local destination folder exists
mkdir -p "$LOCAL_DESTINATION"

# Download folder content recursively using scp
echo "Downloading content from $REMOTE_FOLDER on $REMOTE_SERVER to $LOCAL_DESTINATION..."
scp -r "$REMOTE_SERVER:$REMOTE_FOLDER" "$LOCAL_DESTINATION"

# Check if the download was successful
if [ $? -eq 0 ]; then
  echo "Download completed successfully!"
else
  echo "An error occurred during download. Please check your inputs and try again."
fi
