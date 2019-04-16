pipeline {
    agent {
        docker {
            image 'busybox'
        }
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
            string (defaultValue: '*', description: 'Tag Name', name: 'name', trim: false)
            string (defaultValue: '*', description: 'Tag Usage', name: 'usage', trim: false)
    }
   
    stages {
        stage('Example') {
            steps {
                sh "apk add --update groff less python py-pip jq=1.5-r1 && pip install awscli==1.14.10 && apk --purge -v del py-pip && rm -rf /var/cache/apk/*"
                sh "./myscript.sh -d ${params.days} -n ${params.name} -u ${params.usage}"
            }
        }
    }
}
