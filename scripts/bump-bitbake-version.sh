#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
UPSTREAM_REPO="${UPSTREAM_REPO:-https://github.com/openembedded/bitbake.git}"
TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

cd "$TMP_DIR"
git clone --depth 1 "$UPSTREAM_REPO" bitbake
VERSION="$(grep -Po '__version__\s*=\s*['\"']\K[^'\"']+' bitbake/bin/bitbake | head -1)"
if [ -z "$VERSION" ]; then
  echo "Failed to detect version from upstream bitbake/bin/bitbake"
  exit 1
fi
if [[ ! "$VERSION" =~ ^[0-9]+(\.[0-9]+)*$ ]]; then
  echo "Invalid upstream version: $VERSION"
  exit 1
fi

cd "$REPO_ROOT"
CURRENT_VERSION="$(grep -Po '^bitbake-setup \(\K[^\)]+(?=\) UNRELEASED; urgency=low)' debian/changelog | head -1)"
if [ -z "$CURRENT_VERSION" ]; then
  echo "Failed to detect current version from debian/changelog"
  exit 1
fi

echo "Upstream version: $VERSION"
echo "Current package version: $CURRENT_VERSION"

if [ "$VERSION" = "$CURRENT_VERSION" ]; then
  echo "No upstream version change detected."
  echo "$VERSION"
  exit 0
fi

CURRENT_VERSION_SED="${CURRENT_VERSION//./\\.}"
sed -i "1s|^bitbake-setup (${CURRENT_VERSION_SED}) UNRELEASED; urgency=low$|bitbake-setup (${VERSION}) UNRELEASED; urgency=low|" debian/changelog
sed -i "3s|^  \\* Version ${CURRENT_VERSION_SED} \\.$|  * Version ${VERSION} .|" debian/changelog

echo "Updated debian/changelog to $VERSION"
echo "$VERSION"
