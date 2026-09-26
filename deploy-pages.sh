#!/usr/bin/env bash
# Deploy the Coinbase Starter Guide to Cloudflare Pages.
# Run this in YOUR OWN terminal (git-bash). A browser tab will open for OAuth —
# click Allow while it is open; the callback window is short.
set -e
cd "$(dirname "$0")"

echo "==> 1/3  Authenticating with Cloudflare (a browser tab will open)..."
npx --yes wrangler@latest login || npx --yes wrangler@latest login

echo "==> 2/3  Creating the Pages project (safe to re-run if it already exists)..."
npx --yes wrangler@latest pages project create coinbase-starter-guide --production-branch main || true

echo "==> 3/3  Deploying dist/ ..."
npx --yes wrangler@latest pages deploy dist \
  --project-name coinbase-starter-guide \
  --branch main \
  --commit-hash "$(git rev-parse HEAD 2>/dev/null || echo local)" \
  --commit-message "deploy coinbase-starter-guide"

echo
echo "Done. The live URL is printed above (https://coinbase-starter-guide.pages.dev)."
