#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
o=`pwd`
if [ "$1" = "test" ]; then
    target="extra.test"
else
    target="extra"
fi
ftp="osgeowosid@ftp.cluster023.hosting.ovh.net"

scp $DIR/genini $ftp:
ssh $ftp "cd www/$target; ../../genini --arch x86_64 --recursive --output=x86_64/setup.ini x86_64"
ssh $ftp "rm -f www/$target/x86_64/setup.ini.bz2; bzip2 -k www/$target/x86_64/setup.ini"
cd $o
