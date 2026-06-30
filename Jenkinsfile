pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDS = credentials('dockerhub-creds')
        KUBECONFIG = credentials('kubeconfig')
    }

    stages {
        stage('Pull Latest Images') {
            steps {
                sh '''
                    /usr/local/bin/docker pull abhayraj01/founderbrain-backend:latest
                    /usr/local/bin/docker pull abhayraj01/founderbrain-frontend:latest
                    /usr/local/bin/docker pull abhayraj01/founderbrain-ml:latest
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                    /opt/homebrew/bin/helm upgrade founderbrain \
                        $HOME/Desktop/founderbrain-devops/helm/founderbrain \
                        --namespace founderbrain \
                        --values $HOME/Desktop/founderbrain-devops/helm/founderbrain/values.yaml \
                        --set backend.image=abhayraj01/founderbrain-backend:latest \
                        --set frontend.image=abhayraj01/founderbrain-frontend:latest \
                        --set mlservice.image=abhayraj01/founderbrain-ml:latest
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    /opt/homebrew/bin/kubectl rollout status deployment/founderbrain-backend -n founderbrain
                    /opt/homebrew/bin/kubectl rollout status deployment/founderbrain-frontend -n founderbrain
                    /opt/homebrew/bin/kubectl rollout status deployment/founderbrain-ml -n founderbrain
                    /opt/homebrew/bin/kubectl get pods -n founderbrain
                '''
            }
        }
    }

    post {
        success {
            echo 'FounderBrain deployed successfully on EKS!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
