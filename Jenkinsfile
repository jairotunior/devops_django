pipeline{
    agent any
    environment{
        AWS_DEFAULT_REGION='us-east-1'
        AWS_CREDENTIALS=credentials('aws-credentials')
    }
    parameters{
        string(name:'CONFIG_FOLDER', defaultValue:'', description:'')
        string(name:'REPOSITORY_URL', defaultValue:'', description:'')
    }
    stages {
        stage('Git Clone'){
            steps{
                sh 'git clone ${REPOSITORY_URL}'
            }
        }
        stage('SV Config Files'){
            steps{
                sh "trivy fs  --security-checks secret ./${CONFIG_FOLDER}/"
            }
        }
        stage('IaC'){
            steps{
                sh 'run_iac.sh'
            }
        }
        stage('Unit Test'){
            steps{
                sh ''
            }
        }
        stage('Docker Build'){
            steps{
                sh 'docker build -t livery/django-web-app:latest .'
            }
        }
        stage('Scanner Docker Image'){
            steps{
                sh 'trivy --no-progress --exit-code 1 --severity MEDIUM,HIGH,CRITICAL livery/django-web-app:latest'
            }
        }
        stage('Integration Test'){
            steps{
                sh 'run_integration_test.sh'
            }
        }
        stage('Push Images'){
            steps{
                sh 'docker login -u ${}'
                sh 'docker push livery/django-web-app:latest'
            }
        }
        stage('Deploy'){
            steps{
                sh ''
            }
        }
    }
}