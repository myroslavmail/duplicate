pipeline {
    agent {
        dockerfile true
    }
    
    options{
        buildDiscarder(
            logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '180', numToKeepStr: '')
        )
    }
    
    triggers {
        cron('H H/3 * * *')
    }
    
    parameters {
            string (defaultValue: '21', description: 'days parameter', name: 'Days', trim: false)
            string (defaultValue: '12', description: 'weeks parameter', name: 'Weeks', trim: false)
            string (defaultValue: '6', description: 'months parameter', name: 'Months', trim: false)
            string (defaultValue: 'Ubuntu', description: 'Tag Name', name: 'Name', trim: false)
            string (defaultValue: 'Daily', description: 'Tag Usage', name: 'Usage', trim: false)
    }
   
    stages {
        stage('Example') {
            steps {
                sh "./myscript.sh -d ${params.Days} -w ${params.Weeks} -m ${params.Months} -n ${params.Name} -u ${params.Usage}"
            }
        }
    }
}
