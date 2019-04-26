***The idea is to create declarative Jenkins pipeline which should be running inside of a docker container which should be launched from the parametrized script.***

Сomments to the content:

# Jenkinsfile

Jenkinsfile contains the brings the following data:
- docker container information is specified inside of a dockerfile
- logs of the running jobs should be held for no longer then 180 days (surely, adjustable value)
- cronjob, launching every (default value) 3 hours
- default parameter values, descriptions and names
- the string which running the parametrized script

The main thing to pay your attention at, is surely a script:
```sh
 ./myscript.sh -d ${params.Days} -w ${params.Weeks} -m ${params.Months} -n ${params.Name} -u ${params.Usage}
```
d, w, m - numeric values and n, u - text values. It's critically important to type them all! Null values are not validated and you'll get error on the output if decide to test it out
- d - number of days
- w - number of weeks
- m - number of months
- n - the name(value) of the tag "Name"
- u - the name(value) of the tag "Usage"

# Dockerfile

In my case all processes are running on the Alpine container with all packets needed to make it run properly.

# myscript.sh

***explanation to some vars:***
-  $x - value which helping us to identify when snapshot has been taken (In our case 3 options:  last day of the month (monthly), specific day of the week (weekly) or whenever else (usual)
-  $vol_ids - extracting volume ids, based on the applied tag filer 
-  $tags_list - collect all volume tags, which includes all filtered tags, plus all other that volume has.
-  $volume_backup function -> creates a snapshot with all the tags that volume has, plus it ads an Extra_Tag which is names $x
-  $tag_name - the value of the tag which key is "Name"
-  $tag_usage - the value of  the tag which key is "Usage"
-  $rem_days - days values parameter typed in before the job has started
-  $rem_day - defines the date value, based on $rem_days value offtaken from the current date
-  $rem_daily - collects and sorts snapshot ID's from all snapshot taken with $x = "Usual" value
-  $rem_weeks - weeks value parameter typed in before the job has started
-  $rem_week - defines the date value, based on $rem_weeks value offtaken from the current date
-  $rem_weekly - collects and sorts snapshot ID's from all snapshot taken with $x = "Weekly" value
-  $rem_months - months value parameter typed in before the job has started
-  $rem_month - defines the date value, based on $rem_months value offtaken from the current date
-  $rem_monthly - collects and sorts snapshot ID's from all snapshot taken with $x = "Monthly" value
-  $data_maintenance function -> it's a sum of $rem_daily, $rem_weekly and $rem_monthly
-  $usage - help invoked with -h argument (can be added/adjusted via jenkinsfile)
-  $key - the name of the argument
-  $arg - the value of the argument
-  $OPTARG - the value of the parameter (next, we asign new variable to it)
-  $OPTIND - (optional value), helps us to avoid argument1 to capture argument2 in case if empty value has been typed in, e.g "-d -w", instead of "-d 100 -w 40")

***explanation to some lines:***

```sh
if [ `date +%F` = `date -d "-$(date +%d) days month" +%F` ]; then
    x=Monthly
echo x value is $x
```

if NOW (the moment when snapshot meant to be taken) is equal to the last day of current month, then "monthly" value is assigned to the var $x.

```sh
elif [ `date +%w` -eq 6 ]; then
    x=Weekly
echo x value is $x
```

if NOW (the moment when snapshot meant to be taken) is equal to 6th day of the week, then "weekly" value is assigned to the var $x.

```sh
while [[ $# -gt 0 ]] && getopts "hn:u:d:w:m:" key; do
case $key in
```

This piece of the code, will work in case if at least one parameter will be running (not a mandatory condition at least for a reason that we have 5 paramteres assigned inside of the Jenkinsfile). Valid parameters are held within breckets.
