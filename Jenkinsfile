pipeline{
    agent any
    environment{
        IMAGE_NAME = 'react-ecom-app'
        DOCKERHUB_USERNAME = 'zera18'
        TAG = 'latest'
    }
    stages{
        stage("git checkout"){
            steps{
                git url 'https://github.com/zerajudeen-zera/devops-react-app.git'

            }
            

        }
        stage("build"){
            steps{
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
        stage("push"){
            steps{
                script{
                    if(env.BRANCH_NAME == 'dev'){
                        sh "docker tag ${IMAGE_NAME}:${TAG} ${DOCKERHUB_USERNAME}/${IMAGE_NAME}-dev:${TAG}"
                        sh "docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}-dev:${TAG}"
                    } else if(env.BRANCH_NAME == 'master'){
                        sh "docker tag ${IMAGE_NAME}:${TAG} ${DOCKERHUB_USERNAME}/${IMAGE_NAME}-prod:${TAG}"
                        sh "docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}-prod:${TAG}"
                    }
                }

            }

        }
        stage("deploy"){
            steps{
                sh './deploy.sh'
            }

        }
    }
}