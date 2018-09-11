#!/bin/bash
#
# Exécute le container docker dgricci/deck2pdf
#
# Constantes :
VERSION="1.0.1"
# Variables globales :
unset dryrun
unset noMoreOptions
#
# Exécute ou affiche une commande
# $1 : code de sortie en erreur
# $2 : commande à exécuter
run () {
    local code=$1
    local cmd=$2
    if [ -n "${dryrun}" ] ; then
        echo "cmd: ${cmd}"
    else
        eval ${cmd}
    fi
    [ ${code} -ge 0 -a $? -ne 0 ] && {
        echo "Oops #################"
        exit ${code#-} #absolute value of code
    }
    [ ${code} -ge 0 ] && {
        return 0
    }
}
#
# Affichage d'erreur
# $1 : code de sortie
# $@ : message
echoerr () {
    local code=$1
    shift
    echo "$@" 1>&2
    usage ${code}
}
#
# Usage du shell :
# $1 : code de sortie
usage () {
    cat >&2 <<EOF
usage: `basename $0` [--help -h] | [--dry-run|-s] argumentsAndOptions

    --help, -h          : prints this help and exits
    --dry-run, -s       : do not execute deck2pdf, just show the command to be executed

    argumentsAndOptions : arguments and/or options to be handed over to deck2pdf
EOF
    exit $1
}
#
# main
#
proxyEnv=""
[ ! -z "${http_proxy}" ] && {
    proxyEnv="-e http_proxy=${http_proxy}"
}
[ ! -z "${https_proxy}" ] && {
    proxyEnv="${proxyEnv} -e https_proxy=${https_proxy}"
}
cmdToExec="docker run ${proxyEnv} -v /tmp/.X11-unix:/tmp/.X11-unix:ro -e DISPLAY"
cmdToExec="${cmdToExec} -e USER_ID=${UID} -e USER_GP=`id -g` -e USER_NAME=${USER}"
cmdToExec="${cmdToExec} --name=\"deck2pdf$$\" --rm"
cmdToExec="${cmdToExec} -v `pwd`:/decks -w/decks dgricci/deck2pdf deck2pdf"
while [ $# -gt 0 ]; do
    # protect back argument containing IFS characters ...
    arg="$1"
    [ $(echo -n ";$arg;" | tr "$IFS" "_") != ";$arg;" ] && {
        arg="\"$arg\""
    }
    if [ -n "${noMoreOptions}" ] ; then
        cmdToExec="${cmdToExec} $arg"
    else
        case $arg in
        --help|-h)
            run -1 "${cmdToExec} --help"
            usage 0
            ;;
        --dry-run|-s)
            dryrun=true
            noMoreOptions=true
            ;;
        --)
            noMoreOptions=true
            ;;
        *)
            [ -z "${noMoreOptions}" ] && {
                noMoreOptions=true
            }
            cmdToExec="${cmdToExec} $arg"
            ;;
        esac
    fi
    shift
done

run 100 "${cmdToExec}"
cmdToExec="rmdir hsperfdata_${USER}"
run 200 "${cmdToExec}"

exit 0

