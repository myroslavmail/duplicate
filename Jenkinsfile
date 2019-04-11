pipeline {
    agent { docker { image 'busybox' } }
    stages {
        stage('Example') {
            steps {
                sh "chmod 755 ./myscript.sh"
                sh "./myscript.sh -d 10 -t name"
            }
        }
    }
}
