pipeline {
    agent any

    stages {
        stage('Example') {
            steps {
                sh "ls -laR ./"
                sh "chmod 755 ./myscript.sh"
                sh "./myscript.sh"
            }
        }
    }
}
