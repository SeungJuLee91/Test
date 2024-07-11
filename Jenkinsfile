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
