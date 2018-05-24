#!/bin/bash

QMLPLUGINDUMP=${QMLPLUGINDUMP-qmlplugindump}

case $1 in
-h|--help)
    echo "Usage: $(basename $0) [IMPORT_PATH]"
    echo "it uses either '$(which qmlplugindump)' or the one set by 'QMLPLUGINDUMP'"
    exit 1
;;
esac

cmd="${QMLPLUGINDUMP} -v -noinstantiate -notrelocatable -platform minimal"
curpath=`dirname $0`
rootpath=`dirname $(readlink -e $curpath)`

function update() {
    impname=$1
    impver=$2
    module=$3

    echo "Update $impname $impver ..."
    $cmd $impname $impver > $rootpath/src/imports/$module/plugins.qmltypes
}

update Liri.NetworkManager 1.0 networkmanager
