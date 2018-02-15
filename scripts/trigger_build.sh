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
else
    repo=http://hekla.oslandia.net/osgeo4w
fi
url=$repo/x86_64/release/$P/$PKG_BIN

if [ ! -f "$DIR/TOKEN" ]; then
    echo "No TOKEN file found !"
    echo "You need a trigger token to be able to trigger build."
    echo "This token must be stored in a file named TOKEN"
    exit 1
fi

# curl -I only tests HEAD
is_200=$(curl -I $url 2>/dev/null | grep ^"HTTP" | grep "200")
if [ -n "$is_200" ]; then
    echo "The package already exists at $url"
    if [ "$3" != "--overwrite" ]; then
        exit 1
    fi
    echo "Overwriting ..."
fi

token=$(cat "$DIR/TOKEN")
out=$(curl --request POST \
     --form token=$token \
     --form ref=master \
     --form "variables[PACKAGE_NAME]=$1" \
     --form "variables[DELIVERY_ENV]=$2" \
     https://git.oslandia.net/api/v4/projects/140/trigger/pipeline)
url=$(echo $out| python3 -c "import sys; import json; print('https://git.oslandia.net/Oslandia-infra/osgeo4w/pipelines/{}'.format(json.load(sys.stdin)['id']))")
echo $out
echo "Pipeline:" $url
xdg-open $url

