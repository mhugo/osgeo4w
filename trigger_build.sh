#!/bin/bash
if [ -z "$1" ]; then
    echo "Argument: package_name release|test"
    exit 1
fi
P=$(grep ^"set P" $1/package.cmd | cut -d'=' -f2)
V=$(grep ^"set V" $1/package.cmd | cut -d'=' -f2)
B=$(grep ^"set B" $1/package.cmd | cut -d'=' -f2)
PKG_BIN=$P-$V-$B.tar.bz2
if [ "$2" = "test" ]; then
    repo=http://hekla.oslandia.net/osgeo4w.test
else
    repo=http://hekla.oslandia.net/osgeo4w
fi
url=$repo/x86_64/release/$P/$PKG_BIN

# curl -I only tests HEAD
is_404=$(curl -I $url 2>/dev/null | grep ^"HTTP" | grep "200")
if [ -n "$is_404" ]; then
    echo "The package already exists at $url"
    exit 1
fi

exit 1
out=$(curl --request POST \
     --form token=983ea4f789964e464c97dd1f7028b9 \
     --form ref=master \
     --form "variables[PACKAGE_NAME]=$1" \
     --form "variables[DELIVERY_ENV]=$2" \
     https://git.oslandia.net/api/v4/projects/140/trigger/pipeline)
url=$(echo $out| python3 -c "import sys; import json; print('https://git.oslandia.net/Oslandia-infra/osgeo4w/pipelines/{}'.format(json.load(sys.stdin)['id']))")
echo $out
echo "Pipeline:" $url
xdg-open $url

