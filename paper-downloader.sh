#!/bin/sh

function printAvailableVersions() {
  printf 'Available versions: '
  curl -s 'https://papermc.io/api/v2/projects/paper' | jq -c '.versions'
}

if [ $# != 1 ]; then
  echo 'Usage: ./paper-downloader.sh <Version>'
  printAvailableVersions
  exit 1
fi

Result=$(curl -s "https://papermc.io/api/v2/projects/paper/versions/$1")
Status=$(echo $Result | jq '.status')

if [ $Status != "null" ]; then
    echo "ERROR: Not found version($1)"
    printAvailableVersions
    exit 2
fi

LatestBuild=$(echo $Result | jq '.builds | max')

curl -O "https://papermc.io/api/v2/projects/paper/versions/$1/builds/$LatestBuild/downloads/paper-$1-$LatestBuild.jar"
