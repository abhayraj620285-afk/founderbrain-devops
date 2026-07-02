pipeline {
    agent any

    environment {
        DOCKER_CONFIG = "/tmp/jenkins-docker-config"
        PATH = "/usr/local/bin:/opt/homebrew/bin:$PATH"
    }

    stages {
        stage('Setup Docker Config') {
            steps {
                sh '''
                    mkdir -p /tmp/jenkins-docker-config
                    echo '{"auths":{}}' > /tmp/jenkins-docker-config/config.json
                '''
            }
        }

        stage('Pull Latest Images') {
            steps {
                sh '''
                    docker pull abhayraj01/founderbrain-backend:latest
                    docker pull abhayraj01/founderbrain-frontend:latest
                    docker pull abhayraj01/founderbrain-ml:latest
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh '''
                        export KUBECONFIG=$KUBECONFIG
                        helm upgrade founderbrain \
                            $WORKSPACE/helm/founderbrain \
                            --namespace founderbrain \
                            --values $WORKSPACE/helm/founderbrain/values.yaml \
                            --set backend.image=abhayraj01/founderbrain-backend:latest \
                            --set frontend.image=abhayraj01/founderbrain-frontend:latest \
                            --set mlservice.image=abhayraj01/founderbrain-ml:latest \
                            --force
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh '''
                        export KUBECONFIG=$KUBECONFIG
                        kubectl rollout status deployment/founderbrain-backend -n founderbrain
                        kubectl rollout status deployment/founderbrain-frontend -n founderbrain
                        kubectl rollout status deployment/founderbrain-ml -n founderbrain
                        kubectl get pods -n founderbrain
                    '''
                }
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
