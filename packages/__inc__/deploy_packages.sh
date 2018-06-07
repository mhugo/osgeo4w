# $1 target (test|release)
# $2 arch (x86|x86_64)
# $3 local absolute path to be deployed
# $4 override main packages ? (override|)
ARCH=$2
P=$3
if [ "$1" = "release" ]; then 
    RELEASE_HOST=ci@hekla.oslandia.net
    RELEASE_PATH=/mnt/osgeo4w_ftp/www/extra/${ARCH}/release/extra
fi
if [ "$1" = "test" ]; then
    RELEASE_HOST=ci@hekla.oslandia.net
    RELEASE_PATH=/mnt/osgeo4w_ftp/www/extra.test/${ARCH}/release/extra
fi

if [ "$4" = "override" ]; then
    scp -r ${P}/* ${RELEASE_HOST}:${RELEASE_PATH}/../zzz_override
else
    scp -r ${P}/* ${RELEASE_HOST}:${RELEASE_PATH}
fi
