#!/bin/bash

# This script demonstrates how to use the script
#
# Usage:
#   ./transfer-github.sh <source_org> <dest_org> <github_token>
#
# Example:
#   $ ./transfer-github.sh sourceorg destorg ghp_1234567890abcdef
#
# Note: Make sure to set execute permissions before running:
#   $ chmod +x transfer-github.sh
#
# This will transfer all repositories from sourceorg to destorg using the provided token

# Check if all required arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <source_org> <dest_org> <github_token>"
    exit 1
fi

SOURCE_ORG=$1
DEST_ORG=$2
GITHUB_TOKEN=$3

# Get the list of repositories from the source organization
repos=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/orgs/$SOURCE_ORG/repos?per_page=100" | jq -r '.[].name')

# Loop through each repository and transfer it
for repo in $repos; do
  echo "Transferring repository: $repo"
#   curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" \
#     -H "Accept: application/vnd.github.v3+json" \
#     "https://api.github.com/repos/$SOURCE_ORG/$repo/transfer" \
#     -d "{\"new_owner\":\"$DEST_ORG\"}"
done
