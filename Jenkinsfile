pipeline {
    agent any

    stages {
        stage('Example') {
            steps {
                chmod 755 ./my_script.sh
                ./myscript.sh
            }
        }
    }
}
