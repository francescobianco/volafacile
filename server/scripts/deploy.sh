#!/usr/bin/env bash
set -e

## Install the repo
if [ ! -d /opt/volafacile ]; then
  echo "$1" | sudo -S bash -c '
    apt-get install -y git make;
    git config --global --add safe.directory /opt/volafacile;
    git clone https://github.com/francescobianco/volafacile /opt/volafacile;
  '
fi

cd /opt/volafacile

echo "==> Update"
echo "$1" | sudo -S git pull

if [ ! -f .env ]; then
  echo "$1" | sudo -S cp .env.prod .env
fi

echo "==> Restart"
echo "$1" | sudo -S make restart
