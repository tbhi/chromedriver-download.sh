#!/bin/sh
CHROME_VERSION=$(google-chrome --version | sed -En 's/.* ([0-9]+).*/\1/p')
DRIVER_VERSION=$(chromedriver --version | sed -En 's/.* ([0-9.]+).*/\1/p')
LATEST_DRIVER_VERSION=$(curl -s https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION)
[ "$DRIVER_VERSION" = "$LATEST_DRIVER_VERSION" ] && exit 0
DIR="$(mktemp -d)"
curl -so "$DIR"/chromedriver.zip https://chromedriver.storage.googleapis.com/$LATEST_DRIVER_VERSION/chromedriver_linux64.zip
unzip "$DIR"/chromedriver.zip -d "$DIR"/out
INSTALL_DIR="$(dirname "$(which chromedriver || echo $0)")"
find "$DIR/out" -type f -perm /u+x -exec mv {} "$INSTALL_DIR" \;
echo installed version "$LATEST_DRIVER_VERSION"
rm -rf "$DIR"
