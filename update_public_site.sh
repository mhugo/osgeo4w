#!/bin/bash
# mirrors the official owgeo4w and adds/overload custom packages
#
# ssh access is required for public (ftp.cluster023.hosting.ovh.net)

# extract list of packages from official setup.ini
# extract list of packages from custom setup.ini
# 
# for source in [official, custom]:
#   for package in source
#     if package_is_availabe_in_public and checksum_matches:
#         pass
#     else:
#         dowload
#    
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
                printf "%s" $ct
                ct=$(printf '\rtransfering %s ' $1)
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

official="download.osgeo.org/osgeo4w" 
custom="osgeo4w.oslandia.net/osgeo4w"
public="ftp.cluster023.hosting.ovh.net"

for source in $official; do
    echo fetching setup.ini from $source
    setup=$(wget -q -O- $source/x86_64/setup.ini| grep x86_64/release )
    packages=$(printf "$setup" | cut -f2 -d' ')
    dest_files=$(printf "$packages" | sed 's|\(.*\)|www/osgeo4w/\1|' | xargs echo)

    nb_pack=$(printf "$setup" | wc -l)

    dest_dir=$(dirname $dest_files| xargs echo)

    echo creating directory structure in $public
    ssh $public "mkdir -p $dest_dir"

    #echo $dest_dir
    echo getting md5 sums from $public
    dest_md5=$(ssh $public "md5sum $dest_files" 2> /dev/null)
    i=0
    printf "$setup" | while read package; do
        arr=($package)
        md5=${arr[3]}
        fil=${arr[1]}
        res=$(printf "$dest_md5" | grep $fil | cut -f1 -d' ')
        i=$(($i + 1))
        progress=$(echo "scale=2; (100.0*$i)/$nb_pack" | bc)
        if [ "$md5" != "$res" ]; then
            LC_NUMERIC="C" printf "\r%-$(($(tput cols) - 8))s %5.1f%%" "$fil" $progress
            { wget --progress=bar:force -O- $source/$fil 2>&3 | ssh $public "cat > www/osgeo4w/$fil" ; } 3>&1 1>&2 | progressfilt $fil > /dev/stdout
        else
            LC_NUMERIC="C" printf "\r%-$(($(tput cols) - 8))s %5.1f%%" "skipping $fil" $progress
        fi
    done
    printf "\r%-$(tput cols)s\n" "done"

done
