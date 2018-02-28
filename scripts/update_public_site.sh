#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

extra_dir="/home/storage/osgeo4w"
extra_test_dir="/home/storage/osgeo4w.test"
extra_ftp="/mnt/osgeo4w_ftp/www/extra/"
extra_test_ftp="/mnt/osgeo4w_ftp/www/extra.test/"
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
find $extra_dir -type f | sed s#$extra_dir/## > /tmp/extra_files
rsync -av --delete --exclude-from=/tmp/extra_files $mirror_ftp $extra_ftp
$DIR/gen_setup_ini.sh release
echo
echo ----------- EXTRA test -----------
find $extra_test_dir -type f | sed s#$extra_test_dir/## > /tmp/extra_test_files
rsync -av --delete --exclude-from=/tmp/extra_test_files $mirror_ftp $extra_test_ftp
$DIR/gen_setup_ini.sh test    




