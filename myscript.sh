#!/bin/bash

volume_backup () {
    echo "Backing up volumes filtered by '$OPTARG' tag(s)"
    if [ $? -eq 0 ]; then
        echo OK
    else
        echo FAIL
        exit 1
    fi
}

data_maintenance () {
    echo "Remove backed up snapshot(s) when '$OPTARG' days old, except those that not !created on Sat and/or 31||30||29||28 day of the month"
    if [ $? -eq 0 ]; then
        echo OK
    else
        echo FAIL
        exit 1
    fi
}

usage () {
    echo "$(basename "$0") [-h] [-d -t] -- this is help description to my script

where:
    -h show this help text
    -v volume tag
    -r removal time"
    exit 0
}


while [[ $# -gt 0 ]] && getopts "ht:d:" key; do
case $key in
    d) arg=${OPTARG#-}
    if [[ "$arg" = "${OPTARG}" ]]; then
        echo "Removal is initiated" && data_maintenance
    else
        echo "Removal value can't be the empty space"
        OPTIND=$OPTIND-1
        exit 1
    fi
    ;;
    t) arg=${OPTARG#-}
    if [[ "$arg" = "${OPTARG}" ]]; then
        echo "Tags are correct" && volume_backup
    else
        echo "Tag value can't be the empty space"
        OPTIND=$OPTIND-1
        exit
    fi
    ;;
    h)
    usage
    exit
    ;;
esac
done
