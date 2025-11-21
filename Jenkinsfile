pipeline {
    agent any
    
    environment {
        SONAR_TOKEN = credentials('SONAR_TOKEN_CREDENTIAL_ID')
    }
    
    stages {
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh '''
                        sonar-scanner \
                        -Dsonar.projectKey=your-project-key \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=${SONAR_HOST_URL} \
                        -Dsonar.login=${SONAR_TOKEN}
                    '''
                }
            }
        }
    }
}