#!/bin/bash

function usage
{
    echo "Options:"
    echo -e "-n, --name NAME\t\tName of the installer"
    echo -e "-v, --version VERSION\tVersion of the installer"
    echo -e "-p, --package PACKAGE\tOSGEO4W package name to install"
    echo -e "-r, --repository URL\tOSGEO4W repository URL (default=http://osgeo4w.oslandia.net/osgeo4w)"
    echo
    echo "This will output a Windows installer named setup-NAME-VERSION.exe"
}

INSTALLER_NAME=
INSTALLER_VERSION=
INSTALLER_EXTRA_CMD=
OSGEO4W_REPO=http://osgeo4w.oslandia.net/osgeo4w
PACKAGES=

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -n|--name)
    INSTALLER_NAME="$2"
    shift
    ;;
    -v|--version)
    INSTALLER_VERSION="$2"
    shift
    ;;
    -p|--package)
    PACKAGES="$PACKAGES $2"
    shift
    ;;
    -r|--repository)
    OSGEO4W_REPO="$2"
    shift
    ;;
    *)
        echo "Unknown option $1"
        usage
        exit 1
    ;;
esac
shift # past argument or value
done

if [ -z $INSTALLER_NAME ]; then
    echo "Missing installer name"
    usage
    exit 1
fi
if [ -z $INSTALLER_VERSION ]; then
    echo "Missing installer version"
    usage
    exit 1
fi
if [ -z "$PACKAGES" ]; then
    echo "Missing package list"
    usage
    exit 1
fi

HERE=`pwd`

rm -rf /tmp/osgeo4w
mkdir /tmp/osgeo4w
cd /tmp/osgeo4w

wget -nc $OSGEO4W_REPO/x86_64/setup.ini
for f in $(python $HERE/pkg_deps.py setup.ini)
do
    wget -nH -r --cut-dirs=1 $SERVER/$f
done
7z a arc.7z x86_64
cd $HERE
7z a /tmp/osgeo4w/arc.7z osgeo4w-setup-x86_64.exe

cat > /tmp/config.txt <<EOF
;!@Install@!UTF-8!
RunProgram="osgeo4w-setup-x86_64.exe -A -l %%T -L -k"
;!@InstallEnd@!
EOF
cat 7zsd_all.sfx /tmp/config.txt /tmp/osgeo4w/arc.7z > setup-${INSTALLER_NAME}-${INSTALLER_VERSION}-local.exe
