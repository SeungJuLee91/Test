pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: jnlp
    image: jenkins/inbound-agent
    args: ['\$(JENKINS_SECRET)', '\$(JENKINS_NAME)']
  - name: docker
    image: docker:19.03-dind
    securityContext:
      privileged: true
    volumeMounts:
    - name: docker-graph-storage
      mountPath: /var/lib/docker
    env:
    - name: DOCKER_TLS_CERTDIR
      value: ""
  volumes:
  - name: docker-graph-storage
    emptyDir: {}
"""
        }
    }
    stages {
        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/SeungJuLee91/Test.git'
            }
        }
        stage('Build Dockerfile') {
            steps {
                sh '''
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
                '''
            }
        }
        stage('Build Images') {
            steps {
                sh '''
                    docker -H tcp://localhost:2375 pull node:14
                    docker -H tcp://localhost:2375 pull nginx:alpine
                    docker -H tcp://localhost:2375 build --target build-stage -t ubersys/test-image:build .
                    docker -H tcp://localhost:2375 build --target final-stage -t ubersys/test-image:final .
                '''
            }
        }
        stage('Scan Build Image') {
            steps {
                prismaCloudScanImage (
                    ca: '',
                    cert: '',
                    dockerAddress: 'unix:///var/run/docker.sock',
                    image: 'ubersys/test-image:build',
                    key: '',
                    logLevel: 'info',
                    podmanPath: '',
                    project: '',
                    resultsFile: 'prisma-cloud-scan-build-image-results.json',
                    ignoreImageBuildTime: true
                )
            }
        }
        stage('Scan Final Image') {
            steps {
                prismaCloudScanImage (
                    ca: '',
                    cert: '',
                    dockerAddress: 'unix:///var/run/docker.sock',
                    image: 'ubersys/test-image:final',
                    key: '',
                    logLevel: 'info',
                    podmanPath: '',
                    project: '',
                    resultsFile: 'prisma-cloud-scan-final-image-results.json',
                    ignoreImageBuildTime: true
                )
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
