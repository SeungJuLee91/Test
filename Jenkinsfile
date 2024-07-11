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
                    docker pull node:14
                    docker pull nginx:alpine
                    echo "FROM node:14 AS build-stage" > Dockerfile
                    echo "WORKDIR /app" >> Dockerfile
                    echo "COPY package*.json ./" >> Dockerfile
                    echo "RUN npm install" >> Dockerfile
                    echo "COPY . ." >> Dockerfile
                    echo "RUN npm run build" >> Dockerfile
                    echo "FROM nginx:alpine" >> Dockerfile
                    echo "COPY --from=build-stage /app/build /usr/share/nginx/html" >> Dockerfile
                    echo "EXPOSE 80" >> Dockerfile
                    echo "CMD ['nginx', '-g', 'daemon off;']" >> Dockerfile
                    docker build -t your-dockerhub-username/test-image:build .
                    docker build -t your-dockerhub-username/test-image:final .
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
                        image: 'your-dockerhub-username/test-image:build',
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
                script {
                    prismaCloudScanImage (
                        ca: '',
                        cert: '',
                        dockerAddress: 'unix:///var/run/docker.sock',
                        image: 'your-dockerhub-username/test-image:final',
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
