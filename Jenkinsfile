pipeline {
    agent { docker { image 'busybox' } }
    stages {
        properties([parameters([string(defaultValue: '180', description: 'days parameter', name: 'days', trim: false), string(defaultValue: 'name', description: 'volume tags', name: 'tags', trim: false)])])
        stage('Example') {
            steps {
                sh "ls -la"
                sh "chmod 755 ./myscript.sh"
                sh "./myscript.sh -d ${params.days} -t ${params.tags}"
            }
        }
    }
}
