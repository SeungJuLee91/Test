pipeline {
    agent any

    stages {
        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/SeungJuLee91/Test.git'
            }
        }

        stage('Install Docker') {
            steps {
                sh '''
                    #!/bin/bash
                    set -e
                    if ! [ -x "$(command -v docker)" ]; then
                        curl -fsSL https://get.docker.com -o get-docker.sh
                        sudo sh get-docker.sh
                    fi
                    docker --version
                '''
            }
        }

        stage('Build Images') {
            steps {
                // Dockerfile을 빌드하여 이미지를 생성
                sh '''
                    #!/bin/bash
                    set -e
                    docker build --target build-stage -t test/build-image:latest .
                    docker build --target final-stage -t test/final-image:latest .
                '''
            }
        }

        stage('Scan Build Image') {
            steps {
                // 첫 번째 이미지를 스캔
                script {
                    prismaCloudScanImage (
                        ca: '',
                        cert: '',
                        dockerAddress: 'unix:///var/run/docker.sock',
                        image: 'test/build-image:latest',
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

        stage('Scan Final Image') {
            steps {
                // 두 번째 이미지를 스캔
                script {
                    prismaCloudScanImage (
                        ca: '',
                        cert: '',
                        dockerAddress: 'unix:///var/run/docker.sock',
                        image: 'test/final-image:latest',
                        key: '',
                        logLevel: 'info',
                        podmanPath: '',
                        project: '',
                        resultsFile: 'prisma-cloud-scan-final-image-results.json',
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
            // 스캔 결과를 게시
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
