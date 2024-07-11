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
                if ! [ -x "$(command -v docker)" ]; then
                    curl -fsSL https://get.docker.com -o get-docker.sh
                    sh get-docker.sh
                fi
            '''
        }
    }

        stage('Build') {
            steps {
                // Dockerfile 생성 및 이미지 빌드
                sh 'echo "FROM imiell/bad-dockerfile:latest" > Dockerfile'
                sh 'docker build --no-cache -t test/test-image:0.1 .'
            }
        }

        stage('Test') {
            steps {
                sh 'echo Testing...'
            }
        }

        stage('Scan') {
            steps {
                // Scan the image
                prismaCloudScanImage ca: '',
                cert: '',
                dockerAddress: 'unix:///var/run/docker.sock',
                image: 'test/test-image*',
                key: '',
                logLevel: 'info',
                podmanPath: '',
                // The project field below is only applicable if you are using Prisma Cloud Compute Edition and have set up projects (multiple consoles) on Prisma Cloud.
                project: '',
                resultsFile: 'prisma-cloud-scan-results.json',
                ignoreImageBuildTime:true
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
            // The post section lets you run the publish step regardless of the scan results
            prismaCloudPublish (
                resultsFilePattern: 'prisma-cloud-scan-results.json'
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
