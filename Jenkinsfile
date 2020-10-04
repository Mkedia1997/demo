pipeline {
    environment {
        registry = "sahilyadavhere/sapientdemo"
        registryCredential = 'dockerhub_id'
        dockerImage = ''
    }
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Clean Build'
                sh 'mvn clean compile'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing'
                bat 'mvn test'
            }
        }
        stage('Package') {
            steps {
                echo 'Packaging'
                bat 'mvn package -DskipTests'
            }
        }
        stage('JaCoCo') {
            steps {
                echo 'Code Coverage'
                jacoco()
            }
        }
         stage("SonarQube analysis") {
            steps {
              withSonarQubeEnv('SonarQube') {
                  bat 'mvn sonar:sonar'
              }
            }
          }
        stage('Deploy to Prod') {
            when {
                anyOf{
                    branch 'master';
                    branch 'release'
                }
            }
            steps {
                script {
                    dockerImage = docker.build registry + ":prod-v$BUILD_NUMBER"
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                    }
                    bat "docker rmi $registry:prod-v$BUILD_NUMBER"
                }
            }
        }
        stage('Deploy to Dev') {
            when {
                branch 'development'
            }
            steps {
                script {
                    dockerImage = docker.build registry + ":dev-v$BUILD_NUMBER"
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                    }
                    bat "docker rmi $registry:dev-v$BUILD_NUMBER"
                }
            }
        }
    }
    
    post {
        always {
            echo 'JENKINS PIPELINE'
            junit 'target/surefire-reports/*.xml'
        }
        success {
            echo 'JENKINS PIPELINE SUCCESSFUL'
            archiveArtifacts artifacts: 'target/*.*', onlyIfSuccessful: true
        }
        failure {
            echo 'JENKINS PIPELINE FAILED'
        }
        unstable {
            echo 'JENKINS PIPELINE WAS MARKED AS UNSTABLE'
        }
        changed {
            echo 'JENKINS PIPELINE STATUS HAS CHANGED SINCE LAST EXECUTION'
        }
    }
}
