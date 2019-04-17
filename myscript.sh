#!/bin/sh

volume_backup () {
#   vol_id=$(aws ec2 describe-volumes --profile backup --filters Name=tag:Name,Values=$tag_name Name=tag:Usage,Values=$tag_usage --query "Volumes[].{ID:VolumeId}" --output=text)
    $vol_ids=$(aws ec2 describe-volumes --profile backup --filters Name=tag:Name,Values=$tag_name Name=tag:Usage,Values=$tag_usage --query "Volumes[].{ID:VolumeId}" --output=text)
    echo $vol_ids|while read line; do
        aws ec2 create-snapshot --profile backup --volume-id $line --tag-specifications 'ResourceType=snapshot,Tags=[{Key="*",Value="*"}]';
    done
    
    # aws ec2 describe-volumes --profile backup --filters Name=tag:Name,Values=$tag_name Name=tag:Usage,Values=$tag_usage --query "Volumes[].{Tag:Tags}" --output=text|while read -r a b c; do echo $a $b $c; done
#   $vol_tags | while read -r a b c; do echo $b $c; done
#   $vol_id | while read line; do aws ec2 create-snapshot --profile backup --volume-id $line --tag-specifications 'ResourceType=snapshot,Tags=[{Key="*",Value="*"}]'; done
    if [ $? -eq 0 ]; then
        echo snapshot is taken
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
        echo "Tag is correct and my optarg is $OPTARG"
        tag_name=$OPTARG
        echo "Now tag_name is $tag_name"
    else
        echo "Tag value can't be the empty space"
        OPTIND=$OPTIND-1
        exit 1
    fi
    ;;
    u) arg=${OPTARG#-}
    if [[ "$arg" = "${OPTARG}" ]]; then
        echo "Tag is correct and my optarg is $OPTARG"
        tag_usage=$OPTARG
        echo "Now tag_usage is $tag_usage"
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
