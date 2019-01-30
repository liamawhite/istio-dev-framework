#! /bin/bash

RELEASES_DIR=$GOPATH/src/istio.io/releases

OS="$(uname)"
if [ "x${OS}" = "xDarwin" ] ; then
  OSEXT="osx"
else
  OSEXT="linux"
fi

ISTIO_VERSION=$(curl -L https://api.github.com/repos/istio/istio/releases | jq -r '.[].tag_name' | grep snapshot | head -1)

NAME="istio-$ISTIO_VERSION"
URL="https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-${OSEXT}.tar.gz"

cd $RELEASES_DIR
echo "Downloading into $(pwd)/$NAME from $URL ..."
curl -L "$URL" | tar xz
