#!/bin/sh

#collecting snapshots to be excluded from removal
collect () {
for w in $(seq -w 1 54)
do
    sat_snap_list=$(aws ec2 describe-snapshots --profile backup --filters Name=volume-id,Values=vol-0ca889652aa1f9bb8,vol-011fc1e91e9bdb9b5,vol-00161d785e1ce2446 Name=tag:Day_Week,Values=1 Name=tag:Week,Values="$w" --output=json --query 'Snapshots[0].SnapshotId');
    if [ $sat_snap_list != null ]; then
        echo $sat_snap_list;
    fi
done

for m in $(seq -w 1 12)
do
    mon_snap_list=$(aws ec2 describe-snapshots --profile backup --filters Name=volume-id,Values=vol-0ca889652aa1f9bb8,vol-011fc1e91e9bdb9b5,vol-00161d785e1ce2446 Name=tag:Month,Values="$m" --output=json --query 'Snapshots[0].SnapshotId');
    if [ $mon_snap_list != null ]; then
        echo $mon_snap_list;
    fi
done
}


#creating snapshots for the specified volumes as per specified tags
volume_backup () {
    vol_ids=$(aws ec2 describe-volumes --profile backup --filters Name=tag:Name,Values=$tag_name Name=tag:Usage,Values=$tag_usage --query "Volumes[].VolumeId" --output=text)
    echo Volume IDs are $vol_ids
    echo $vol_ids|while read line; do
        tags_list=$(aws ec2 describe-volumes --profile backup --volume-ids $line --output=json|jq .Volumes[].Tags[]|tr -d ' +\n"'|sed -r 's/\}\{/\}\,\{/g'|tr ':' '=');
        aws ec2 create-snapshot --profile backup --volume-id $line --tag-specifications 'ResourceType=snapshot,Tags=['$tags_list',{Key=Day,Value='$(date +%d)'},{Key=Month,Value='$(date +%m)'},{Key=Week,Value='$(date +%V)'},{Key=Day_Week,Value='$(date +%u)'},{Key=Clock_Time,Value='$(date +%X)'}]';
    done
    if [ $? -eq 0 ]; then
        echo snapshot is taken
    else
        echo FAIL 1
        exit 1
    fi
}

#collect snapshots to be removed
data_maintenance () {
    rem_date=$(date +%FT%X -d "-$rem_days days")
    rem_snaps=$(aws ec2 describe-snapshots --profile backup --filters Name=volume-id,Values=vol-0ca889652aa1f9bb8,vol-011fc1e91e9bdb9b5,vol-00161d785e1ce2446 --output=json --query "Snapshots[?StartTime<='$rem_date'].SnapshotId[]"|tr -d ' +,[]')
    echo $rem_snaps;
}

usage () {
    echo "$(basename "$0") [-h] [-d -n -u] -- this is help description to my script

where:
    -h show this help text
    -v volume tag
    -r removal time"
    exit 0
}

# configuring scrip arguments
while [[ $# -gt 0 ]] && getopts "hn:u:d:" key; do
case $key in
    d) arg=${OPTARG#-}
    if [[ "$arg" = "${OPTARG}" ]]; then
        rem_days=$OPTARG
        echo "Now rem_days values is $rem_days" #&& data_maintenance
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
echo !!!! DO COLLECT !!!
#var11=$(collect | tr ' ' '\n' | sort | uniq | tr ' ' '\n')
collect | tr ' ' '\n' | sort | uniq
collect | tr ' ' '\n' | sort | uniq > file1
#echo $var11
#echo $var11 > file1
#echo !!!! DO VOLUME BACKUP !!!
#volume_backup
echo !!!! DATA MAINTENANCE !!!
#var22=$(data_maintenance | tr ' ' '\n'| sort | uniq | tr ' ' '\n')
data_maintenance | tr ' ' '\n'| sort | uniq
data_maintenance | tr ' ' '\n'| sort | uniq > file2
#echo $var22
#echo $var22 > file2
echo !!!! COMPILE A LIST OF SNAPSHOTS TO BE REMOVED AND REMOVE THOSE !!!
#echo $var11 $var22 | tr ' ' '\n' | sort | uniq -u
echo1
awk 'NR==FNR{a[$0]=1;next}!a[$0]' file2 file1
echo2
awk 'NR==FNR{a[$0]=1;next}!a[$0]' file1 file2
