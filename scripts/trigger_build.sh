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

if [ -e $DIR/../packages/$1/package.sh ]; then
    P=$(grep ^"P=" $DIR/../packages/$1/package.sh | cut -d'=' -f2)
    V=$(grep ^"V=" $DIR/../packages/$1/package.sh | cut -d'=' -f2)
    B=$(grep ^"B=" $DIR/../packages/$1/package.sh | cut -d'=' -f2)
else
    P=$(grep ^"set P=" $DIR/../packages/$1/package.cmd | cut -d'=' -f2)
    V=$(grep ^"set V=" $DIR/../packages/$1/package.cmd | cut -d'=' -f2)
    B=$(grep ^"set B=" $DIR/../packages/$1/package.cmd | cut -d'=' -f2)
fi

PKG_BIN=$P-$V-$B.tar.bz2

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
project_url=$(grep ^URL "$DIR/$CONFIG" | cut -d'=' -f2)
api_token=$(grep ^API_TOKEN "$DIR/$CONFIG" | cut -d'=' -f2)

if [ "$2" = "test" ]; then
    repo=$(curl -s --header "Private-Token: $api_token" $project_url/variables/DEPLOY_TEST_SERVER | jq -r ".value")
elif [ "$2" = "release" ]; then
    repo=$(curl -s --header "Private-Token: $api_token" $project_url/variables/DEPLOY_RELEASE_SERVER | jq -r ".value")
else
    echo "Unknown target '$2'. Targets available: release, test"
    exit 1
fi
if [ "null" = "$repo" ]; then
    echo "Undefined deploy server"
fi

url=$repo/x86_64/release/extra/$P/$PKG_BIN

# curl -I only tests HEAD
is_200=$(curl -I $url 2>/dev/null | grep ^"HTTP" | grep "200")
if [ -n "$is_200" ]; then
    echo "The package already exists at $url"
    if [ $overwrite == 0 ]; then
        exit 1
    fi
    echo "Overwriting ..."
fi

base_url=$(curl -s --header "Private-Token: $api_token" $project_url | jq -r ".web_url")
out=$(curl -s --request POST \
     --form token=$token \
     --form ref=$branch \
     --form "variables[PACKAGE_NAME]=$1" \
     --form "variables[DELIVERY_ENV]=$2" \
     ${project_url}/trigger/pipeline)
pipeline_id=$(echo $out| jq -r ".id" )
if [ "$pipeline_id" = "null" ]; then
    echo "Problem launching pipeline"
    echo $out
    exit 1
fi
url=$base_url/pipelines/$pipeline_id
echo "Pipeline:" $url
xdg-open $url

