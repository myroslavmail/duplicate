pipeline {
    agent any

    stages {
        stage('Example') {
            steps {
                sh "ls -laR ./"
                sh "chmod 755 ./my_script.sh"
                sh "./myscript.sh"
            }
        }
    }
}
