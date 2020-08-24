pipeline {
    agent none
    stages {
        stage('build') {
            agent any
            steps {
                sh 'docker ps'
            }
        }
        stage('test') {
            agent { docker { image 'python:3.7.2' } }
            steps {
                sh 'pip install flask'
                sh 'pip install -e .'
                sh 'pip install pytest coverage'
                sh 'pytest --junitxml=test-reports/results.xml'
            }
            post {
                always {junit 'test-reports/*.xml'}
            }
        }
        stage('build docker image') {
            agent any
            steps {
                sh 'docker build -t flaskr:latest .'
            }
        }
    }
}
