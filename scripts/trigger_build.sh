#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -z "$1" ]; then
    echo "Argument: package_name release|test [--overwrite]"
    exit 1
fi
P=$(grep ^"set P=" ../packages/$1/package.cmd | cut -d'=' -f2)
V=$(grep ^"set V=" ../packages/$1/package.cmd | cut -d'=' -f2)
B=$(grep ^"set B=" ../packages/$1/package.cmd | cut -d'=' -f2)

PKG_BIN=$P-$V-$B.tar.bz2
if [ "$2" = "test" ]; then
    repo=http://hekla.oslandia.net/osgeo4w.test
elif [ "$2" = "release" ]; then
    repo=http://hekla.oslandia.net/osgeo4w
else
    echo "Unknown target '$2'. Targets available: release, test"
    exit 1
fi
url=$repo/x86_64/release/$P/$PKG_BIN

if [ -z "$CONFIG" ]; then
    CONFIG=config.oslandia
else
    CONFIG=config.$CONFIG
fi

if [ ! -f "$DIR/$CONFIG" ]; then
    echo "No $DIR/$CONFIG file found !"
    exit 1
fi

token=$(grep ^TOKEN "$DIR/$CONFIG" | cut -d'=' -f2)
trigger_url=$(grep ^URL "$DIR/$CONFIG" | cut -d'=' -f2)

# curl -I only tests HEAD
is_200=$(curl -I $url 2>/dev/null | grep ^"HTTP" | grep "200")
if [ -n "$is_200" ]; then
    echo "The package already exists at $url"
    if [ "$3" != "--overwrite" ]; then
        exit 1
    fi
    echo "Overwriting ..."
fi

out=$(curl --request POST \
     --form token=$token \
     --form ref=master \
     --form "variables[PACKAGE_NAME]=$1" \
     --form "variables[DELIVERY_ENV]=$2" \
     ${trigger_url}/trigger/pipeline)
url=$(echo $out| python3 -c "import sys; import json; print('https://git.oslandia.net/Oslandia-infra/osgeo4w/pipelines/{}'.format(json.load(sys.stdin)['id']))")
echo $out
echo "Pipeline:" $url
xdg-open $url

