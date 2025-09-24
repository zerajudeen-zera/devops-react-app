properties([
  parameters([
    string(name: 'BRANCH_NAME', defaultValue: 'main', description: 'Branch to build (e.g., main or dev)'),
    string(name: 'AMAZON_EC2_USER', defaultValue: 'ubuntu', description: 'EC2 user name'),
    string(name: 'AMAZON_EC2_IP', defaultValue: '172.31.3.49', description: 'IP private IP'),
    string(name: 'COMPOSE_FILE', defaultValue: 'docker-compose.yml', description: 'Compose file path'),
    string(name: 'KEY_PATH', defaultValue: '/var/lib/jenkins/.ssh/key.pem', description: 'kep file path')
  ])
])

pipeline{
    agent any
    environment{
        IMAGE_NAME = 'react-ecom-app'
        DOCKERHUB_USERNAME = 'zera18'
        TAG = 'latest'
        AMAZON_EC2_USER = "ubuntu"
        AMAZON_EC2_IP = "172.31.3.49"
        COMPOSE_FILE = "docker-compose.yml"
        KEY_PATH = "/var/lib/jenkins/.ssh/key.pem"

    }
    stages{
        stage("building image."){
            steps{
                sh 'chmod +x build.sh'
                sh './build.sh'
            }

        }
        stage('Docker Login'){
            steps{
                withCredentials([usernamePassword(credentialsId:'docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]){
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                }

            }

        }
        stage("push image"){
            steps{
                script{
                    if(env.BRANCH_NAME == 'dev'){
                        sh "docker tag ${IMAGE_NAME}:${TAG} ${DOCKERHUB_USERNAME}/${IMAGE_NAME}-dev:${TAG}"
                        sh "docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}-dev:${TAG}"
                    } else if(env.BRANCH_NAME == 'main'){
                        sh "docker tag ${IMAGE_NAME}:${TAG} ${DOCKERHUB_USERNAME}/${IMAGE_NAME}-prod:${TAG}"
                        sh "docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}-prod:${TAG}"
                    }
                }

            }

        }
        stage("deploy"){
            when{
                expression { BRANCH_NAME == 'main'}
            }
            steps{
                sh 'chmod +x deploy.sh'
                sh './deploy.sh'
            }

        }
    }
}