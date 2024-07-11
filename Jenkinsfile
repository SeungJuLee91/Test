pipeline {
    agent any

    stages {
        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/SeungJuLee91/Test.git'
            }
        }

        stage('Build') {
            steps {
                sh 'echo Building...'
            }
        }

        stage('Test') {
            steps {
                sh 'echo Testing...'
            }
        }

        stage('Prisma Cloud Scan') {
            steps {
                script {
                    prismaCloudScan (
                        consoleURI: 'http://192.168.70.190:8083',
                        accessKey: 'ubersys',
                        secretKey: 'Ubersys123!@#',
                        compliancePolicy: 'Default - ignore Twistlock components',
                        audit: true,
                        imageName: 'docker.io/username/myapp:latest'
                    )
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'echo Deploying...'
            }
        }
    }

    post {
        success {
            echo 'Build was successful!'
        }
        failure {
            echo 'Build failed.'
        }
    }
}
