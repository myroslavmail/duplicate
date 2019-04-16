#!/bin/sh

volume_backup () {
    aws_vol_id=$(aws ec2 describe-volumes --profile backup --filters Name=tag:Name,Values='$OPTARG' Name=tag:Usage,Values='$OPTARG' --query "Volumes[].{ID:VolumeId}" --output=text)
    echo this is my optarg $OPTARG "$OPTARG"
    #aws ec2 describe-volume-status --profile backup --volume-ids $aws_vol_id
    #aws ec2 create-snapshot --volume-id @aws_vol_id --tag-specifications 'ResourceType=snapshot,Tags=[*]'
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
    echo "$(basename "$0") [-h] [-d -n -u] -- this is help description to my script

where:
    -h show this help text
    -v volume tag
    -r removal time"
    exit 0
}


while [[ $# -gt 0 ]] && getopts "hn:u:d:" key; do
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
    n) arg=${OPTARG#-}
    if [[ "$arg" = "${OPTARG}" ]]; then
        echo "Tag is correct"
    else
        echo "Tag value can't be the empty space"
        OPTIND=$OPTIND-1
        exit 1
    fi
    ;;
    u) arg=${OPTARG#-}
    if [[ "$arg" = "${OPTARG}" ]]; then
        echo "Tag is correct"
    else
        echo "Tag value can't be the empty space"
        OPTIND=$OPTIND-1
        exit 1
    fi
    ;;
    h)
    usage
    exit
    ;;
esac
done
volume_backup
