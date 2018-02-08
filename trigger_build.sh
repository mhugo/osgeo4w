#!/bin/bash
if [ -z "$1" ]; then
    echo "Argument: package_name release|test"
    exit 1
fi
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

