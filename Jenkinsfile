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
        stage('deploy') {
            agent any
            steps {
                script {
                    //sh 'docker build -t flaskr:latest .'
                    withDockerRegistry([ credentialsId: "docker-creds", url: "" ]) {
                        def customImage = docker.build("flaskr:${env.BUILD_ID}")
                        customImage.push()
                    }
                }
            }
        }
    }
}
