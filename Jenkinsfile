pipeline {
    agent { docker { image 'bash' } }
    stages {
        stage('Example') {
            steps {
                sh "chmod 755 ./myrscript.sh"
                sh "./myscript.sh -d 10 -t name"
            }
        }
    }
}
