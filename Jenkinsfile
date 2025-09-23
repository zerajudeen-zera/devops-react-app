properties([
  parameters([
    string(name: 'BRANCH_NAME', defaultValue: 'main', description: 'Branch to build (e.g., main or dev)')
  ])
])

pipeline{
    agent any
    environment{
        IMAGE_NAME = 'react-ecom-app'
        DOCKERHUB_USERNAME = 'zera18'
        TAG = 'latest'
    }
    stages{
        stage("building image"){
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
        stage("push"){
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