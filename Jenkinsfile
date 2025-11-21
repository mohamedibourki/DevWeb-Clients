pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('SONAR_TOKEN_CREDENTIAL_ID') // Load token from Jenkins credentials
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm // Pull code from repo
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') { // Inject SONAR_HOST_URL and SONAR_TOKEN
                    sh '''
                        # Run SonarScanner
                        /tmp/sonar-scanner/bin/sonar-scanner \
                          -Dsonar.projectKey=DevWeb-Clients \
                          -Dsonar.sources=. \
                          -Dsonar.sourceEncoding=UTF-8
                    '''
                }
            }
        }

        stage('Wait for Quality Gate') {
            steps {
                script {
                    // Wait longer for Quality Gate (increase to 15 minutes)
                    timeout(time: 15, unit: 'MINUTES') {
                        def qg = waitForQualityGate abortPipeline: true // Fail pipeline if QG is red
                        echo "Quality Gate status: ${qg.status}"
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'SonarQube analysis completed'
        }
        success {
            echo 'Quality Gate passed!'
        }
        failure {
            echo 'Quality Gate failed or timed out!'
        }
    }
}
