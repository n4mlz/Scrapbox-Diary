#!/bin/sh
set -eu

: "${PROJECT_NAME:?PROJECT_NAME is required}"
: "${PAGE_TITLE:?PAGE_TITLE is required}"
: "${CONNECT_SID:?CONNECT_SID is required}"

raw_content=$(mktemp)
converted_content=$(mktemp)
trap 'rm -f "$raw_content" "$converted_content"' EXIT

curl --fail --silent --show-error --location \
  --cookie "connect.sid=${CONNECT_SID}" \
  "https://scrapbox.io/api/pages/${PROJECT_NAME}/${PAGE_TITLE}/text" \
  --output "$raw_content"
npx --yes @hogashi/sb2md@latest < "$raw_content" > "$converted_content"
sed '1d' "$converted_content" > src/content/diary.md
pnpm run build
