#!/bin/bash

OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize options
overwrite=0
branch=master

print_help(){
    echo "Argument: package_name [-f, -b <branch>] release|test"
    echo "   -f forcibly overwride existing package"
    echo "   -b <branch> use <branch instead of master>"
    echo "   -c <config> use config.<config> instead of config.gitlab or config.\$CONFIG"
}

while getopts "hfb:c:" opt; do
    case "$opt" in
    h)  print_help
        exit 0
        ;;
    f)  overwrite=1
        ;;
    b)  branch=$OPTARG
        ;;
    c)  CONFIG=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

# end of option parsing

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -z "$1" ]; then
    print_help
    exit 1
fi

P=$(grep ^"set P=" $DIR/../packages/$1/package.cmd | cut -d'=' -f2)
V=$(grep ^"set V=" $DIR/../packages/$1/package.cmd | cut -d'=' -f2)
B=$(grep ^"set B=" $DIR/../packages/$1/package.cmd | cut -d'=' -f2)

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
    CONFIG=config.gitlab
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
    if [ $overwrite == 0 ]; then
        exit 1
    fi
    echo "Overwriting ..."
fi

base_url=$(curl $trigger_url 2>/dev/null | python3 -c "import sys; import json; print(json.load(sys.stdin)['web_url'])")
out=$(curl --request POST \
     --form token=$token \
     --form ref=$branch \
     --form "variables[PACKAGE_NAME]=$1" \
     --form "variables[DELIVERY_ENV]=$2" \
     ${trigger_url}/trigger/pipeline)
url=$(echo $out| python3 -c "import sys; import json; print('${base_url}/pipelines/{}'.format(json.load(sys.stdin)['id']))")
echo $out
echo "Pipeline:" $url
xdg-open $url

