pipeline {
    agent any

    environment {
        DOCKER_VERSION = '20.10.7'
    }

    stages {
        stage('Install Docker') {
            steps {
                sh '''
                    #!/bin/bash
                    set -e
                    if ! [ -x "$(command -v docker)" ]; then
                      echo "Docker is not installed. Installing Docker..."
                      apt-get update
                      apt-get install -y apt-transport-https ca-certificates curl software-properties-common
                      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
                      add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
                      apt-get update
                      apt-get install -y docker-ce=${DOCKER_VERSION}~3-0~ubuntu-focal
                      usermod -aG docker jenkins
                    else
                      echo "Docker is already installed."
                    fi
                '''
            }
        }

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
                    cat <<EOF > Dockerfile
                    FROM node:14 AS build-stage
                    WORKDIR /app
                    COPY package*.json ./
                    RUN npm install
                    COPY . .
                    RUN npm run build
                    FROM nginx:alpine
                    COPY --from=build-stage /app/build /usr/share/nginx/html
                    EXPOSE 80
                    CMD ["nginx", "-g", "daemon off;"]
                    EOF
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
