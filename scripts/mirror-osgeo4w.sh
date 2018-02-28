#!/bin/bash

from=rsync://download.osgeo.org/download/osgeo4w
to=/mnt/osgeo4w_ftp/www/mirror

echo -e "Content-Type: text/plain\r\n\r"

cd $to

if ! lockfile -r0 mirroring; then
    echo Mirror in progress since $(date -r mirroring)
    exit 0
fi

echo "Starting sync..."

(
    trap "rm -f $PWD/mirroring" EXIT

    exec >>/tmp/osgeo4w-mirror.log 2>&1

    rm -f /tmp/osgeo4w-files

    for a in x86 x86_64; do
	mkdir -p $a
	echo "$(date): Downloading $a/setup.ini."
	rsync $from/$a/setup.ini.bz2 $a/setup.ini.bz2
	bzcat $a/setup.ini.bz2 >$a/setup.ini

	perl -ne 'print "/$1\n" if /^(?:install|source|license): (\S+) .*$/;' $a/setup.ini >>/tmp/osgeo4w-files
    done

    rsync --max-delete=-1 --delete --inplace -a --stats --files-from=/tmp/osgeo4w-files $from/ ./
    echo "$(date): Syncing done [$?]"
) &
