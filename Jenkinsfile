pipeline {
    agent none
    environment {
        registry = "penaltydbl/flaskr"
        registryCredential = 'docker-creds'
        dockerImage = ''
    }
    stages {
        stage('build') {
            agent any
            steps {
                sh 'docker ps'
                sh 'ansib
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
        stage('Building image') {
            steps{
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }
      
        stage('Publish Image') {
            steps{
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                        dockerImage.push('latest')
                    }
                }
            }
        }
        stage('Deploy Image') {
            agent any
            steps{
                script {
                        def image_id = registry + ":$BUILD_NUMBER"
                        sh "ansible-playbook deploy.yml -i inv"
                        //ansiblePlaybook(credentialsId: 'jenkins-host-ssh-creds', inventory: 'inv', playbook: 'deploy.yml')
                }
            }
        }
    }
}
