pipeline {
    agent any
    stages {
        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/SeungJuLee91/Test.git'
            }
        }
        stage('Build Images') {
            steps {
                sh '''
                    #!/bin/bash
                    set -e
                    docker pull hello-world:latest

                '''
            }
        }
        
        stage('Scan Build Image') {
            steps {
                script {
                    prismaCloudScanImage (
                        ca: '',
                        cert: '',
                        dockerAddress: 'unix:///var/run/docker.sock',
                        image: 'hello-world:latest',
                        key: '',
                        logLevel: 'info',
                        podmanPath: '',
                        project: '',
                        resultsFile: 'prisma-cloud-scan-build-image-results.json',
                        ignoreImageBuildTime: true
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
        always {
            prismaCloudPublish (
                resultsFilePattern: 'prisma-cloud-scan-*-results.json'
            )
        }
        success {
            echo 'Build was successful!'
        }
        failure {
            echo 'Build failed.'
        }
    }
}
