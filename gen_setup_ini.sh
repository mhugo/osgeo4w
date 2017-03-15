#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
o=`pwd`
if [ "$1"="test" ]; then
    cd /home/storage/osgeo4w.test
else
    cd /home/storage/osgeo4w
fi
$DIR/genini --arch x86_64 --recursive --output=setup.ini x86_64

# get original setup.ini from osgeo
wget http://download.osgeo.org/osgeo4w/x86_64/setup.ini -O setup_orig.ini
# merge it after our setup.ini
cat setup.ini <(echo -e "\n##========= End of Oslandia's specific packages ========\n\n") <(tail -n +8 setup_orig.ini) > x86_64/setup.ini
rm setup.ini
rm setup_orig.ini

rm -f x86_64/setup.ini.bz2
bzip2 -k x86_64/setup.ini
cd $o
