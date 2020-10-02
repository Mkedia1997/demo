pipeline { 
    agent any  
    stages {
         stage('Compile') { 
            steps { 
               sh 'mvn compile'
            }
         }
        stage("build & SonarQube analysis") {
            steps {
              withSonarQubeEnv('project-1') {
                  sh 'mvn sonar:sonar'
              }
            }
          }
        stage('build') { 
            steps { 
               sh 'mvn install'
            }
        }
    }
}
