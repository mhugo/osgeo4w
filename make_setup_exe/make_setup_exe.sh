#!/bin/bash

OSGEO4W_REPO=http://osgeo4w-oslandia.com/extra
DEFAULT_INSTALL_PATH=C:\osgeo4w64

function usage
{
    echo "Options:"
    echo -e "-n, --name NAME\t\tName of the installer"
    echo -e "-v, --version VERSION\tVersion of the installer"
    echo -e "-p, --package PACKAGE\tOSGEO4W package name to install"
    echo -e "-r, --repository URL\tOSGEO4W repository URL (default: $OSGEO4W_REPO)"
    echo -e "-R, --root PATH\tDefault installation path (default=i$DEFAULT_INSTALL_PATH)"
    echo -e "-l, --local\tGenerate a local installer (default: network installer)"
    echo -e "-q, --quiet\tGenerate a quiet installer (default: display OSGeo4W setup)"
    echo -e "-N, --no-update\tDo not update packages when installing (default: do update)"
    echo
    echo "This will output a Windows installer named setup-NAME-VERSION.exe"
}

INSTALLER_NAME=
INSTALLER_VERSION=
INSTALLER_EXTRA_CMD=
PACKAGES=
IS_LOCAL=false
IS_QUIET=false
DO_UPDATE=true
EXTRA_NAME=
EXTRA_PROMPT=

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
	-R|--root)
	    DEFAULT_INSTALL_PATH="$2"
	    shift
	    ;;
	-l|--local)
	    IS_LOCAL=true
	    EXTRA_NAME="$EXTRA_NAME-local"
	    ;;
	-q|--quiet)
	    IS_QUIET=true
	    EXTRA_NAME="$EXTRA_NAME-quiet"
	    ;;
	-N|--no-update)
	    DO_UPDATE=false
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

if [ "$DO_UPDATE" = "true" ]; then
    EXTRA_CMD="$EXTRA_CMD --upgrade-also"
fi

if [ "$IS_LOCAL" = "true" ]; then
    EXTRA_CMD="$EXTRA_CMD -L -l %%T"
else
    EXTRA_CMD="-O -s $OSGEO4W_REPO"
    EXTRA_PROMPT=" from $OSGEO4W_REPO"
fi

if [ "$IS_QUIET" = "true" ]; then
    EXTRA_CMD="$EXTRA_CMD -q"
fi

for p in "$PACKAGES"; do
    echo $p
    EXTRA_CMD="$EXTRA_CMD -P $p"
done

EXTRA_CMD="-R $DEFAULT_INSTALL_PATH -k $EXTRA_CMD"

echo $EXTRA_CMD

HERE=`pwd`

rm -rf /tmp/osgeo4w
mkdir /tmp/osgeo4w
if [ "$IS_LOCAL" = "true" ]; then
    cd /tmp/osgeo4w

    wget -nc $OSGEO4W_REPO/x86_64/setup.ini
    for f in $(python $HERE/pkg_deps.py setup.ini $PACKAGES)
    do
	wget -nH -r --cut-dirs=1 $OSGEO4W_REPO/$f
    done
    7z a arc.7z x86_64
    cd $HERE
    7z a /tmp/osgeo4w/arc.7z osgeo4w-setup-x86_64.exe
else
    cp osgeo4w_setup.7z /tmp/osgeo4w/arc.7z
fi

echo ";!@Install@!UTF-8!" > /tmp/config.txt
echo "Title=\"$INSTALLER_NAME $INSTALLER_VERSION\"" >> /tmp/config.txt
if [ "$IS_QUIET" = "true" ]; then
    echo "BeginPrompt=\"This will install or update $INSTALLER_NAME $INSTALLER_VERSION in $DEFAULT_INSTALL_PATH$EXTRA_PROMPT. Proceed ?\"" >> /tmp/config.txt
fi
echo "RunProgram=\"osgeo4w-setup-x86_64.exe $EXTRA_CMD\"" >> /tmp/config.txt
echo ";!@InstallEnd@!\n" >> /tmp/config.txt

cat 7zS.sfx /tmp/config.txt /tmp/osgeo4w/arc.7z > setup-${INSTALLER_NAME}-${INSTALLER_VERSION}${EXTRA_NAME}.exe

