pipeline {
    agent any
    options {
        skipStagesAfterUnstable()
    }
     environment {
        AWS_ACCOUNT_ID="YOUR_ACCOUNT_ID_HERE"
        AWS_DEFAULT_REGION="CREATED_AWS_ECR_CONTAINER_REPO_REGION" 
        IMAGE_REPO_NAME="ECR_REPO_NAME"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }
    stages {
         stage('Checkout the code') { 
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/sd031/aws_codebuild_codedeploy_nodeJs_demo.git']]]) 
                }
            }
        stage('Build the Docker image') { 
            steps { 
                script {
                dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                }
            }
        }
        stage('Test'){
            steps {
                 echo 'Empty'
            }
        }
         stage('Pushing to ECR') {
            steps{ 
                script {
                    GIT_COMMIT_HASH = sh (script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)
                    sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:${GIT_BRANCH}${GIT_COMMIT_HASH}"
                    sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                }
            }
        }
        stage('Deploy Helm Charts') {
            steps {
                script {
                    sh 'curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash'
                    sh 'helm repo add <repository-name> <repository-url>'
                    sh 'sed -i "s|{{image}}|${IMAGE_TAG}" infra/terraform/modules/k8s-manifests/charts/app/versions.yaml
                    sh 'helm upgrade --install infra/terraform/modules/k8s-manifests/charts/app -n app -f infra/terraform/modules/k8s-manifests/charts/app'
                }
            }
        }
        
    }
}
