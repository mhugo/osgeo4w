#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ftp="osgeowosid@ftp.cluster023.hosting.ovh.net"
mirror_ftp="/mnt/osgeo4w_ftp/www/mirror/"

exec &> >(tee -a /tmp/osgeo4w-update.log)

pid_file=/tmp/osgeo4w-update.pid
# make sure we are the only one running
if [ -f $pid_file ]; then
    p=$(cat $pid_file)
    echo Update in progress in PID $p ... killing
    # retrive the progress group
    kill -TERM -$(ps -ho pgid $p)
    # wait for the file to be deleted
    sleep 1
fi
echo $$ > $pid_file

trap "rm -f $pidfile" EXIT

echo ----------- MIRROR -----------
$DIR/mirror-osgeo4w.sh

echo
echo ----------- EXTRA -----------
sshpass -f /home/ci/.ovh_ftp_pass ssh $ftp 'rsync -av --delete --exclude="x86_64/release/extra/*" www/mirror/ www/extra/'
echo gen_setup_ini ...
$DIR/gen_setup_ini.sh release
echo
echo ----------- EXTRA test -----------
sshpass -f /home/ci/.ovh_ftp_pass ssh $ftp 'rsync -av --delete --exclude="x86_64/release/extra/*" www/mirror/ www/extra.test/'
echo gen_setup_ini ...
$DIR/gen_setup_ini.sh test    




