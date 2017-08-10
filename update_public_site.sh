#!/bin/bash
# mirrors the official owgeo4w and adds/overload custom packages
#
# ssh access is required for server (ftp.cluster023.hosting.ovh.net)

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
# Note: the custom redirects to official and does the overloading, so we actually
#       don't look into official directory (only one element in the outer loop)

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

official="download.osgeo.org/osgeo4w" 
custom="osgeo4w.oslandia.net/osgeo4w"
server="ftp.cluster023.hosting.ovh.net"
public="osgeo4w-oslandia.com/osgeo4w"

for source in $custom; do
    echo transfering setup.ini.bz2 from $source
    { wget --progress=bar:force -O- $source/x86_64/setup.ini.bz2 2>&3 | ssh $server "cat > www/osgeo4w/x86_64/setup.ini.bz2" ; } 3>&1 1>&2 | progressfilt x86_64/setup.ini.bz2 > /dev/stdout
    printf "\runzip $server/wwww/osgeo4w/x86_64/setup.ini.bz2 and get it's contend\n"
    ssh $server "bzip2 -dfk www/osgeo4w/x86_64/setup.ini.bz2"

    setup=$(wget -q -O- $public/x86_64/setup.ini| grep x86_64/release )
    packages=$(printf "$setup" | cut -f2 -d' ')
    dest_files=$(printf "$packages" | sed 's|\(.*\)|www/osgeo4w/\1|' | xargs echo)

    nb_pack=$(printf "$setup" | wc -l)

    dest_dir=$(dirname $dest_files| xargs echo)

    echo creating directory structure in $server
    ssh $server "mkdir -p $dest_dir"

    #echo $dest_dir
    echo getting md5 sums from $server
    dest_md5=$(ssh $server "md5sum $dest_files" 2> /dev/null | sort | uniq)
    i=0
    j=0
    printf "$setup" | sort | uniq | while read package; do
        arr=($package)
        md5=${arr[3]}
        fil=${arr[1]}
        res=$(printf "$dest_md5" | grep $fil | cut -f1 -d' ')
        i=$(($i + 1))
        progress=$(echo "scale=2; (100.0*$i)/$nb_pack" | bc)
        if [ "$md5" != "$res" ]; then
            j=$(($j + 1))
            LC_NUMERIC="C" printf "\r%-$(($(tput cols) - 8))s %5.1f%%" "$fil" $progress
            { wget --progress=bar:force -O- $source/$fil 2>&3 | ssh $server "cat > www/osgeo4w/$fil" ; } 3>&1 1>&2 | progressfilt $fil > /dev/stdout
            new_md5=$(ssh $server "md5sum www/osgeo4w/$fil" | cut -f1 -d' ')
            if [ "$md5" != "$new_md5" ]; then
                echo "$fil md5 doesn't match value in setup.ini" 1>&2
            fi

        fi
    done
    printf "\r%-$(tput cols)s\n" "all done ($j packages updated)"

done
