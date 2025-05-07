#!/bin/bash

# Check if all required arguments are provided
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <source_org> <dest_org> <token>"
  exit 1
fi

SOURCE_ORG=$1
DEST_ORG=$2
GITHUB_TOKEN=$3

echo "Starting repository transfer from $SOURCE_ORG to $DEST_ORG"

# Initialize an empty array for repositories
repos=()
page=1

echo "Fetching repositories..."

# Fetch repositories with pagination
while true; do
  echo "Fetching page $page..."
  # Get repositories for current page
  response=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/orgs/$SOURCE_ORG/repos?per_page=100&page=$page")

  # Get repo names from current page
  page_repos=$(echo "$response" | jq -r '.[].name')

  # Break if no more repositories
  if [ -z "$page_repos" ] || [ "$page_repos" = "" ]; then
    echo "No more repositories found."
    break
  fi

  echo "Found repository: $page_repos"
  # Add repos to the array
  repos+=($page_repos)

  # Increment page counter
  ((page++))
done

echo "Total repositories found: ${#repos[@]}"

# Loop through each repository and transfer it
for repo in "${repos[@]}"; do
  echo "------------------------------"
  echo "Starting transfer for: $repo"
  echo "From: $SOURCE_ORG/$repo"
  echo "To: $DEST_ORG/$repo"

  curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/$SOURCE_ORG/$repo/transfer" \
    -d "{\"new_owner\":\"$DEST_ORG\"}"

  echo "Transfer request sent for: $repo"
done

echo "------------------------------"
echo "Transfer process completed"
