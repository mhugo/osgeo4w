#!/bin/bash
# mirrors the official owgeo4w and adds/overload custom packages
#
# ssh access is required for server (ftp.cluster023.hosting.ovh.net)

# mirrors the official osgeo4w to osgeo4w-oslandia.com

# utilit function to filter wget output and display progress
progressfilt ()
{
    local flag=false c count ct="" cr=$'\r' nl=$'\n'
    while IFS='' read -d '' -rn 1 c
    do
        if $flag
        then
            if [[ $c != $cr ]]
            then
                ct="$ct$c"
            else
                ct=$(echo $ct|sed 's/\[.*\]//')
                printf "%s" "$ct"
                ct=$(printf '\r%s ' $1)
            fi
        else
            if [[ $c != $cr && $c != $nl ]]
            then
                count=0
            else
                ((count++))
                if ((count > 1))
                then
                    flag=true
                fi
            fi
        fi
    done
}

download_to_ssh()
{
    local src=$1 tgt=$2
    if [ "$verbose" = "y" ]; then
        { wget --progress=bar:force -O- $src 2>&3 | ssh $server "cat > $tgt" ; } 3>&1 1>&2 | progressfilt $tgt
    else
        wget -q -O- $src | ssh $server "cat > $tgt"
    fi
}

download_missing_packages()
{
    local src=$1 rep=$2
    echo transfering setup.ini.bz2 from $src
    ssh $server "mkdir -p www/$rep/x86_64"
    
    download_to_ssh $src/x86_64/setup.ini.bz2 www/$rep/x86_64/new_setup.ini.bz2

    printf "\runzip $server/www/$rep/x86_64/new_setup.ini.bz2 and get its content\n"
    ssh $server "bzip2 -dfk www/$rep/x86_64/new_setup.ini.bz2"

    setup=$(wget -q -O- $public/$rep/x86_64/new_setup.ini| grep x86_64/release )
    packages=$(printf "$setup" | cut -f2 -d' ')
    dest_files=$(printf "$packages" | sed "s|\(.*\)|www/$rep/\1|" | xargs echo)

    nb_pack=$(printf "$setup" | wc -l)

    dest_dir=$(dirname $dest_files| xargs echo)

    echo creating directory structure in $server
    ssh $server "mkdir -p $dest_dir"

    #echo $dest_dir
    echo getting md5 sums from $server
    dest_md5=$(ssh $server "md5sum $dest_files" 2> /dev/null | sort | uniq)
    i=0
    printf "$setup" | sort | uniq | while read package; do
        arr=($package)
	md5=${arr[3]}
	fil=${arr[1]}
	res=$(printf "$dest_md5" | grep $fil | cut -f1 -d' ')
	((i++))
	progress=$(echo "scale=2; (100.0*$i)/$nb_pack" | bc)
	if [ "$md5" != "$res" ]; then
            LC_NUMERIC="C" printf "\r%-$(($(tput cols) - 8))s %5.1f%%\n" "$fil" $progress
            download_to_ssh $src/$fil www/$rep/$fil
	fi
    done

    # install the new setup.ini
    ssh $server "mv www/$rep/x86_64/new_setup.ini www/$rep/x86_64/setup.ini"
}

official="download.osgeo.org/osgeo4w" 
custom="osgeo4w.oslandia.net/osgeo4w"
server="ftp.cluster023.hosting.ovh.net"
public="osgeo4w-oslandia.com"
mirror="mirror"
extra="extra"
verbose="n"

if [ -n "$1" -a "$1" = "-v" ]; then
    verbose="y"
fi

echo ----------- MIRROR -----------
download_missing_packages $official $mirror

echo

echo ----------- EXTRA -----------
echo copy mirror to extra
ssh $server "mkdir -p www/$extra/x86_64/release"
#ssh $server "find www/$extra/x86_64/release -type l | xargs rm"
#ssh $server "ln -s $PWD/www/$mirror/x86_64/release/*  www/$extra/x86_64/release"
ssh $server "rsync -r www/$mirror/x86_64/release/*  www/$extra/x86_64/release/"

download_missing_packages $custom $extra



