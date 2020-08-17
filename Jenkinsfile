pipeline {
    agent { docker { image 'python:3.7.2' } }
    stages {
        stage('build') {
            steps {
                sh 'pip install flask'
                sh 'pip install -e .'
            }
        }
        stage('test') {
            steps {
                sh 'pip install pytest coverage'
                sh 'pytest --junitxml=test-reports/results.xml'
            }
            post {
                always {junit 'test-reports/*.xml'}
            }
        }
    }
}
