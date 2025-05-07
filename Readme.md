# Transfer Github ORG

## Clone the repo

backup

```bash
# Authenticate with GitHub
gh auth login

# Replace 'SOURCE_ORG' with your source organization's name
gh repo list SOURCE_ORG --limit 1000 --json name,sshUrl -q ".[] | .sshUrl" | xargs -n1 git clone
```

## Push to the new org

```bash
SOURCE_ORG=source_org_name
DEST_ORG=destination_org_name
GITHUB_TOKEN_SOURCE_ORG=your_github_token_source_org
GITHUB_TOKEN_DEST_ORG=your_github_token_dest_org

./transfer-github.sh $SOURCE_ORG $DEST_ORG $GITHUB_TOKEN_SOURCE_ORG $GITHUB_TOKEN_DEST_ORG
```
