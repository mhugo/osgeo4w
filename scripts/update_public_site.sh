#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ftp="osgeowosid@ftp.cluster023.hosting.ovh.net"
mirror_ftp="/mnt/osgeo4w_ftp/www/mirror/"

if ! lockfile -r0 $mirror_ftp/mirroring; then
    echo Mirror in progress since $(date -r $mirror_ftp/mirroring)
    exit 0
fi

trap "rm -f $mirror_ftp/mirroring" EXIT

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




