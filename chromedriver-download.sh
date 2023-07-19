#!/bin/sh
CHROME_VERSION=$(google-chrome --version | sed -En 's/.* ([0-9]+).*/\1/p')
DRIVER_VERSION=$(chromedriver --version | sed -En 's/.* ([0-9.]+).*/\1/p')
JSON="$(curl -s https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json)"
LATEST_DRIVER_VERSION="$(echo "$JSON" | jq -r .channels.Stable.version)"
[ "$DRIVER_VERSION" = "$LATEST_DRIVER_VERSION" ] && exit 0
DIR="$(mktemp -d)"
curl -so "$DIR"/chromedriver.zip "$(echo "$JSON" | jq -r .channels.Stable.downloads.chromedriver[0].url)"
unzip "$DIR"/chromedriver.zip -d "$DIR"/out
INSTALL_DIR="$(dirname "$(which chromedriver 2>/dev/null || echo $0)")"
find "$DIR/out" -type f -perm /u+x -exec mv {} "$INSTALL_DIR" \;
echo installed version "$LATEST_DRIVER_VERSION"
rm -rf "$DIR"
