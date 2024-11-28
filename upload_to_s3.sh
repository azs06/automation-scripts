#!/bin/bash

# Prompt user for local folder path and S3 bucket details
read -p "Enter the local folder path to upload: " LOCAL_FOLDER
read -p "Enter the S3 bucket name (e.g., my-bucket): " S3_BUCKET
read -p "Enter the S3 bucket path (optional, e.g., folder/subfolder/ or leave blank): " S3_PATH

# Ensure AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it and try again."
    exit 1
fi

# Prompt for AWS credentials if not already configured
if ! aws configure get aws_access_key_id &> /dev/null; then
    echo "AWS credentials not found. Configuring AWS CLI..."
    read -p "Enter your AWS Access Key ID: " AWS_ACCESS_KEY_ID
    read -p "Enter your AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
    read -p "Enter your AWS Default Region (e.g., us-east-1): " AWS_REGION

    aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"
    aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"
    aws configure set region "$AWS_REGION"
fi

# Ensure the local folder exists
if [ ! -d "$LOCAL_FOLDER" ]; then
    echo "Local folder does not exist. Please check the path and try again."
    exit 1
fi

# Construct the S3 destination
if [ -n "$S3_PATH" ]; then
    S3_DEST="s3://$S3_BUCKET/$S3_PATH"
else
    S3_DEST="s3://$S3_BUCKET"
fi

# Upload files to S3 bucket
echo "Uploading files from $LOCAL_FOLDER to $S3_DEST..."
aws s3 cp "$LOCAL_FOLDER" "$S3_DEST" --recursive

# Check if the upload was successful
if [ $? -eq 0 ]; then
    echo "Upload completed successfully!"
else
    echo "An error occurred during the upload. Please check your inputs and try again."
fi
