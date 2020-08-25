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
            steps{
                script {
                    docker.withRegistry( '', registryCredential ) {
                        def image_id = registry + ":$BUILD_NUMBER"
                        ansiblePlaybook(credentialsId: 'ansible_creds', inventory: '/etc/ansible/hosts', playbook: 'deploy.yml')
                    }
                }
            }
        }
    }
}
