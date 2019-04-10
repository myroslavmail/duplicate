pipeline {
    agent { docker { image 'myscript' } }
    stages {
        stage('Example') {
            steps {
                sh "./myscript.sh -d 10 -t name"
            }
        }
    }
}
