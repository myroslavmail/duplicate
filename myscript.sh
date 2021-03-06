#!/bin/sh

set -e

if [ `date +%F` = `date -d "-$(date +%d) days month" +%F` ]; then
    x=Monthly
    echo x value is $x
elif [ `date +%w` -eq 6 ]; then
    x=Weekly
    echo x value is $x
else
    x=Usual
    echo x value is $x
fi

#creating snapshots for the specified volumes as per specified tags
volume_backup () {
    vol_ids=$(aws ec2 describe-volumes --profile backup --filters Name=tag:Name,Values=$tag_name Name=tag:Usage,Values=$tag_usage --query "Volumes[].VolumeId" --output=text)
    echo Volume IDs are $vol_ids
    echo $vol_ids|while read line; do
        tags_list=$(aws ec2 describe-volumes --profile backup --volume-ids $line --output=json|jq .Volumes[].Tags[]|tr -d ' +\n"'|sed -r 's/\}\{/\}\,\{/g'|tr ':' '=');
        aws ec2 create-snapshot --profile backup --volume-id $line --tag-specifications 'ResourceType=snapshot,Tags=['$tags_list',{Key=Extra_Tag,Value='$x'}]';
    done
}

#collect snapshots to be removed
data_maintenance () {
    rem_day=$(date +%FT%X -d "-$rem_days days")
    rem_week=$(date +%FT%X -d "-$rem_weeks weeks")
    rem_month=$(date +%FT%X -d "-$rem_months months")
    rem_daily_snaps=$(aws ec2 describe-snapshots --profile backup --filters Name=tag:Extra_Tag,Values=Usual Name=tag:Name,Values=$tag_name Name=tag:Usage,Values=$tag_usage --output=json --query "Snapshots[?StartTime<='$rem_day'].SnapshotId[]"|tr -d ' +,[]"'|sed '/^$/d')
    rem_weekly_snaps=$(aws ec2 describe-snapshots --profile backup --filters Name=tag:Extra_Tag,Values=Weekly Name=tag:Name,Values=$tag_name Name=tag:Usage,Values=$tag_usage --output=json --query "Snapshots[?StartTime<='$rem_week'].SnapshotId[]"|tr -d ' +,[]"'|sed '/^$/d')
    rem_monthly_snaps=$(aws ec2 describe-snapshots --profile backup --filters Name=tag:Extra_Tag,Values=Monthly Name=tag:Name,Values=$tag_name Name=tag:Usage,Values=$tag_usage --output=json --query "Snapshots[?StartTime<='$rem_month'].SnapshotId[]"|tr -d ' +,[]"'|sed '/^$/d')
    echo $rem_daily_snaps|tr ' +' '\n'|sed '/^$/d';
    echo $rem_weekly_snaps|tr ' +' '\n'|sed '/^$/d';
    echo $rem_monthly_snaps|tr ' +' '\n'|sed '/^$/d';
}

#help
usage () {
    echo "$(basename "$0") [-h] [-d -w -m -n -u] -- this is help description to my script

where:
    -h show this help text
    -d days to remove daily snapshots
    -w weeks to remove weekly snapshots
    -m months to remove monthly snapshots
    -n "Name" tag value
    -u "Usage" tag value"
    exit 0
}


# configuring scrip arguments
while [[ $# -gt 0 ]] && getopts "hn:u:d:w:m:" key; do
case $key in
    d) arg=${OPTARG#-}
    if [[ "$arg" = "${OPTARG}" ]]; then
        rem_days=$OPTARG
        echo "Now rem_days values is $rem_days"
    else
        echo "Removal value can't be the empty space"
        OPTIND=$OPTIND-1
        exit 1
    fi
    ;;
    w) arg=${OPTARG#-}
    if [[ "$arg" = "${OPTARG}" ]]; then
        rem_weeks=$OPTARG
        echo "Now rem_weeks values is $rem_weeks"
    else
        echo "Removal value can't be the empty space"
        OPTIND=$OPTIND-1
        exit 1
    fi
    ;;
    m) arg=${OPTARG#-}
    if [[ "$arg" = "${OPTARG}" ]]; then
        rem_months=$OPTARG
        echo "Now rem_months values is $rem_months"
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
echo !!!! CREATE A SCHEDULED SNAPSHOT BACKUP !!!
volume_backup
echo !!!! SHOW ALL SNAPSHOTS TO BE REMOVED !!!
data_maintenance
echo !!!! NOW REMOVE THEM ALL !!!
data_maintenance|while read line; do
    aws ec2 delete-snapshot --profile backup --snapshot-id $line;
    echo !!!! Snapshot $line has been succesfully removed !!!
done
