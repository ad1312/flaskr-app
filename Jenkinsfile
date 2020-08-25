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
            agent { docker { image 'python:3.7.2' } }
            steps{
                script {
                        def image_id = registry + ":$BUILD_NUMBER"
                        sh "ansible-playbook deploy.yml -i inv -u jenkins --become-user jenkins --private-key /var/jenkins_home/.ssh/id_rsa --extra-vars \"image_id=${image_id}\""
                        //ansiblePlaybook(credentialsId: 'jenkins-host-ssh-creds', inventory: 'inv', playbook: 'deploy.yml')
                }
            }
        }
    }
}
