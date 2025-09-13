pipeline {
    agent any

    environment {
        AWS_CREDS = credentials('AWS_Access_key_ID')
        AWS_REGION = "us-east-1"
        ECR_REPO = "626582779528.dkr.ecr.us-east-1.amazonaws.com/helloworld"
        DOCKER_IMAGE = "${ECR_REPO}:${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/georgeravi/helloworld.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t $DOCKER_IMAGE ."
                }
            }
        }

        stage('Login to ECR & Push Image') {
            steps {
                script {
                    sh """
                        aws ecr get-login-password --region $AWS_REGION | \
                        docker login --username AWS --password-stdin $ECR_REPO
                        docker push $DOCKER_IMAGE
                    """
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    withEnv(["TF_VAR_aws_access_key=${AWS_CREDS_USR}", "TF_VAR_aws_secret_key=${AWS_CREDS_PSW}", "TF_VAR_docker_image=$DOCKER_IMAGE"]) {
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }
}