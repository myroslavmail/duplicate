pipeline {
    agent { docker { image 'busybox' } }
    stages {
        stage('Example') {
            steps {
                sh "which docker"
                sh "chmod 755 ./myrscript.sh"
                sh "./myscript.sh -d 10 -t name"
            }
        }
    }
}
