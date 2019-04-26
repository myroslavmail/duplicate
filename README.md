***The idea is to create declarative Jenkins pipeline. Jenkins job is running inside of a docker container.***

Сomments to the content:

**1. Jenkinsfile**
Jenkinsfile contains the following important information:
- docker container information is specified inside of a dockerfile
- logs of running jobs should be held for no longer then 180 days (adjustable value)
- cronjob, launching every 3 hours
- default parameters values, descriptions and names
- the command line string which running the string with parameters

**2. Dockerfile**
In my case all processes are running on the Alpine container with all packets needed to make it run properly.

**3. myscript.sh**
Key moments:
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
