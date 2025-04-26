pipeline {
    agent any

    environment {
        ACR_NAME = "prodacrjenkinsmohammedaz01"  // <-- your ACR name
        ACR_LOGIN_SERVER = "${ACR_NAME}.azurecr.io"
        IMAGE_NAME = "samplehtml"
        DOCKER_IMAGE = "${ACR_LOGIN_SERVER}/${IMAGE_NAME}:latest"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/MdAyubz/devops-html-pipeline.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }
        stage('Push to ACR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'acr-service-principal', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh """
                        az login --service-principal -u $USERNAME -p $PASSWORD --tenant "474565c1-bca4-4295-a2f5-b0c7dbf2591c"
                        az acr login --name $ACR_NAME
                        docker push $DOCKER_IMAGE
                    """
                }
            }
        }
        stage('Deploy to AKS') {
            steps {
                sh """
                    az aks get-credentials --resource-group rg-jenkins-prod --name prodjenkkub
                    sed "s|<DOCKER_IMAGE>|$DOCKER_IMAGE|g" k8s-deployment-template.yaml > k8s-deployment.yaml
                    kubectl apply -f k8s-deployment.yaml
                """
            }
        }
        stage('Deploy to App Service') {
            steps {
                sh """
                    az webapp config container set --name prod-webapp-service1 --resource-group rg-jenkins-prod --docker-custom-image-name $DOCKER_IMAGE
                """
            }
        }
    }
}

