pipeline {

    agent {
        label 'jenkins-jenkins-agent' // 이미 설정된 에이전트 라벨을 사용합니다.
    }

    stages {
        stage('Clone') {
            steps {
                container('dind') {
                    git branch: 'main', url: 'https://github.com/SeungJuLee91/Test.git'
                }
            }
        }
    }
        stage('Build Images') {
            steps {
                container('dind') {
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
                container('dind') {
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
                container('dind') {
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
