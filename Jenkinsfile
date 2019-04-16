pipeline {
    agent {
        dockerfile true
    }
    
    options{
        buildDiscarder(
            logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '77', numToKeepStr: '')
        )
    }
    
    triggers {
        cron('H H/6 * * *')
    }
    
    parameters {
            string (defaultValue: '180', description: 'days parameter', name: 'days', trim: false)
            string (defaultValue: 'Ubuntu', description: 'Tag Name', name: 'name', trim: false)
            string (defaultValue: 'Daily', description: 'Tag Usage', name: 'usage', trim: false)
    }
   
    stages {
        stage('Example') {
            steps {
                sh "export AWS_DEFAULT_REGION=us-east-1 AWS_DEFAULT_PROFILE=backup"
                sh "./myscript.sh -d ${params.days} -n ${params.name} -u ${params.usage}"
            }
        }
    }
}
