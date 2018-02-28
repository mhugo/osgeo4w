#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
o=`pwd`
if [ "$1" = "test" ]; then
    cd /mnt/osgeo4w_ftp/www/extra.test
else
    cd /mnt/osgeo4w_ftp/www/extra
fi
$DIR/genini --arch x86_64 --recursive --output=x86_64/setup.ini x86_64

rm -f x86_64/setup.ini.bz2
bzip2 -k x86_64/setup.ini
cd $o
