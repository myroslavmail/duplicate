pipeline {
    agent { docker { image 'maven:3.3.3' } }
    stages {
        stage('Example') {
            steps {
                sh "chmod 755 ./myrscript.sh"
                sh "./myscript.sh -d 10 -t name"
            }
        }
    }
}
