# Transfer Github ORG

## Clone the repo

backup

```bash
# Authenticate with GitHub
gh auth login

SOURCE_ORG=source_org_name

gh repo list $SOURCE_ORG --limit 1000 --json name,sshUrl -q ".[] | .sshUrl" | xargs -n1 git clone
```

## Transfer to new Org

```bash
SOURCE_ORG=source_org_name
DEST_ORG=destination_org_name
# please use `Personal access tokens (classic)` for access both orgs in one GITHUB_TOKEN
GITHUB_TOKEN=your_github_token_source_org

./transfer-github.sh $SOURCE_ORG $DEST_ORG $GITHUB_TOKEN
```
