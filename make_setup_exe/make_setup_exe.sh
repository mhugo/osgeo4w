#!/bin/bash

function usage
{
    echo "Options:"
    echo -e "-n, --name NAME\t\tName of the installer"
    echo -e "-v, --version VERSION\tVersion of the installer"
    echo -e "-e, --extra CMD\t\tExtra commands for the setup"
    echo -e "-p, --package PACKAGE\tOSGEO4W package name to install"
    echo
    echo "This will output a Windows installer named setup-NAME-VERSION.exe"
}

INSTALLER_NAME=
INSTALLER_VERSION=
INSTALLER_EXTRA_CMD=
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
    -e|--extra)
    INSTALLER_EXTRA_CMD="$2"
    shift
    ;;
    -p|--package)
    PACKAGES="$PACKAGES $2"
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
if [ -z $PACKAGES ]; then
    echo "Missing package list"
    usage
    exit 1
fi

cat > /tmp/config.txt <<EOF
;!@Install@!UTF-8!
Title="$INSTALLER_NAME $INSTALLER_VERSION"
ExecuteFile="osgeo4w-setup-x86_64.exe"
ExecuteParameters="-A -O -s http://hekla.oslandia.net/osgeo4w -k -P $PACKAGES $INSTALLER_EXTRA_CMD"
;!@InstallEnd@!
EOF
cat 7zS.sfx /tmp/config.txt osgeo4w_setup.7z > setup-${INSTALLER_NAME}-${INSTALLER_VERSION}.exe
