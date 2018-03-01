#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ftp="osgeowosid@ftp.cluster023.hosting.ovh.net"
mirror_ftp="/mnt/osgeo4w_ftp/www/mirror/"

# make sure we are the only one running
for p in $(ps -Ao pgid,args | grep "/bin/bash ./update_public_site.sh" | awk '{print $1}'); do
    if [ "$p" != "$$" ] && [ -d /proc/$p ]; then
	kill -TERM -$p
    fi
done

echo ----------- MIRROR -----------
$DIR/mirror-osgeo4w.sh

echo
echo ----------- EXTRA -----------
ssh $ftp 'rsync -av --delete --exclude="x86_64/release/extra/*" www/mirror/ www/extra/'
echo gen_setup_ini ...
$DIR/gen_setup_ini.sh release
echo
echo ----------- EXTRA test -----------
ssh $ftp 'rsync -av --delete --exclude="x86_64/release/extra/*" www/mirror/ www/extra.test/'
echo gen_setup_ini ...
$DIR/gen_setup_ini.sh test    




