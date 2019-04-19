#!/bin/sh

volume_backup () {
#    vol_ids=$(aws ec2 describe-volumes --profile backup --filters Name=tag:Name,Values=$tag_name Name=tag:Usage,Values=$tag_usage --query "Volumes[].{ID:VolumeId}" --output=text)
#    echo $vol_ids|tr ' +' '\n'
#    echo $vol_ids|tr ' +' '\n'|while read line; do
#        tags_list=$(aws ec2 describe-volumes --profile backup --volume-ids $line --output=json|jq .Volumes[].Tags[]|tr -d ' +\n"'|sed -r 's/\}\{/\}\,\{/g'|tr ':' '=');
#        aws ec2 create-snapshot --profile backup --volume-id $line --tag-specifications 'ResourceType=snapshot,Tags=['$tags_list',{Key=Day_Month,Value='$(date +%d_%m)'},{Key=Day_Week,Value='$(date +%u)'}]';
#    done
#
#    if [ $? -eq 0 ]; then
        echo snapshot is taken
#    else
#        echo FAIL 1
#        exit 1
#    fi
}

data_maintenance () {
    echo "Remove backed up snapshot(s) when '$OPTARG' days old, except those that not !created on Sat and/or 31||30||29||28 day of the month"
    rem_date=$(date +%F -d "-$rem_days days")
    echo $rem_date
    aws ec2 describe-snapshots --profile backup --filters Name=volume-id,Values=vol-00161d785e1ce2446 --output=json --query "Snapshots[?StartTime<=``$rem_date``]"
    
    if [ $? -eq 0 ]; then
        echo OK
    else
        echo FAIL 2
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
        rem_days=$OPTARG
        echo "Now rem_days values is $rem_days"
        echo "Removal is initiated" && data_maintenance
    else
        echo "Removal value can't be the empty space"
        OPTIND=$OPTIND-1
        exit 1
    fi
    ;;
    n) arg=${OPTARG#-}
    if [[ "$arg" = "${OPTARG}" ]]; then
        tag_name=$OPTARG
        echo "Now tag_name is $tag_name"
        echo "Tag is correct and my optarg is $OPTARG"
    else
        echo "Tag Name is empty and that's acceptable"
        exit 0
    fi
    ;;
    u) arg=${OPTARG#-}
    if [[ "$arg" = "${OPTARG}" ]]; then
        tag_usage=$OPTARG
        echo "Now tag_usage is $tag_usage"
        echo "Tag is correct and my optarg is $OPTARG"
    else
        echo "Tag Usage is empty and that's acceptable"
        exit 0
    fi
    ;;
    h)
    usage
    exit
    ;;
esac
done
volume_backup
