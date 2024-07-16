pipeline {
    agent {
        kubernetes {
            label 'mypod'
            defaultContainer 'jnlp'
            yaml """
            apiVersion: v1
            kind: Pod
            spec:
              containers:
              - name: docker
                image: docker:20.10.7
                command:
                - cat
                tty: true
                securityContext:
                  privileged: true
                volumeMounts:
                - name: docker-sock
                  mountPath: /var/run/docker.sock
              - name: nodejs
                image: node:14
                command:
                - cat
                tty: true
              volumes:
              - name: docker-sock
                hostPath:
                  path: /var/run/docker.sock
                  type: Socket
            """
        }
    }
    stages {
        stage('Clone') {
            steps {
                container('jnlp') {
                    git branch: 'main', url: 'https://github.com/SeungJuLee91/Test.git'
                }
            }
        }
        stage('Build Images') {
            steps {
                container('docker') {
                    sh '''
                        #!/bin/bash
                        set -e
                        docker pull node:14
                    '''
                }
            }
        }
        stage('Scan Build Image') {
            steps {
                container('docker') {
                    script {
                        prismaCloudScanImage (
                            ca: '',
                            cert: '',
                            dockerAddress: 'unix:///var/run/docker.sock',
                            image: 'node:14',
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
        }
        stage('Deploy') {
            steps {
                container('nodejs') {
                    sh 'echo Deploying...'
                }
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
