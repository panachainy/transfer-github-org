#!/bin/bash

# Check if all required arguments are provided
if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <source_org> <dest_org> <source_token> <dest_token>"
  exit 1
fi

SOURCE_ORG=$1
DEST_ORG=$2
GITHUB_TOKEN_SOURCE_ORG=$3
GITHUB_TOKEN_DEST_ORG=$4

# Initialize an empty array for repositories
repos=()
page=1

# Fetch repositories with pagination
while true; do
  # Get repositories for current page
  response=$(curl -s -H "Authorization: token $GITHUB_TOKEN_SOURCE_ORG" \
    "https://api.github.com/orgs/$SOURCE_ORG/repos?per_page=100&page=$page")

  # Get repo names from current page
  page_repos=$(echo "$response" | jq -r '.[].name')

  # Break if no more repositories
  if [ -z "$page_repos" ] || [ "$page_repos" = "" ]; then
    break
  fi

  # Add repos to the array
  repos+=($page_repos)

  # Increment page counter
  ((page++))
done

# Loop through each repository and transfer it
for repo in "${repos[@]}"; do
  echo "Transferring repository: $repo"
  curl -s -X POST -H "Authorization: token $GITHUB_TOKEN_DEST_ORG" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/$SOURCE_ORG/$repo/transfer" \
    -d "{\"new_owner\":\"$DEST_ORG\"}"
done
