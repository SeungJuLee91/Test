pipeline {
    agent any

    environment {
        IMAGE_LIST = "nginx node python alpine"
    }

    stages {
        stage('Prisma Cloud Scan Images') {
            steps {
                script {
                    IMAGE_LIST.split().each { image ->
                        def tag = "custom-${image}:${env.BUILD_ID}"
                        def buildContext = "${env.WORKSPACE}/${image}"

                        sh "docker build -t ${tag} ${buildContext}"

                        prismaCloudScanImage(
                            image: tag
                        )
                    }
                }
            }
        }
    }

    post {
        always {
            echo '파이프라인 종료. 정리 중...'
        }
    }
}
