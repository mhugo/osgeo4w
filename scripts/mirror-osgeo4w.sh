#!/bin/bash

from=rsync://download.osgeo.org/download/osgeo4w
to=/mnt/osgeo4w_ftp/www/mirror

echo -e "Content-Type: text/plain\r\n\r"

cd $to

echo "Starting sync..."

(
    #exec >>/tmp/osgeo4w-mirror.log 2>&1

    rm -f /tmp/osgeo4w-files

    for a in x86 x86_64; do
	mkdir -p $a
	echo "$(date): Downloading $a/setup.ini."
	rsync $from/$a/setup.ini.bz2 $a/setup.ini.bz2
	bzcat $a/setup.ini.bz2 >$a/setup.ini

	perl -ne 'print "/$1\n" if /^(?:install|source|license): (\S+) .*$/;' $a/setup.ini >>/tmp/osgeo4w-files
	# add setup.hint
	while IFS='' read -r line; do echo $(dirname $line)/setup.hint; done < /tmp/osgeo4w-files | sort | uniq >/tmp/osgeo4w-files2
	cat /tmp/osgeo4w-files >> /tmp/osgeo4w-files2
    done

    rsync --delete --inplace -av --stats --files-from=/tmp/osgeo4w-files2 $from/ ./
    echo "$(date): Syncing done [$?]"
)
