pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('SONAR_TOKEN_CREDENTIAL_ID')   // Load token from Jenkins credentials
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm   // Pull code from repo
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {   // Inject SONAR_HOST_URL and SONAR_TOKEN
                    sh '''
                        # Run SonarScanner
                        # /tmp/sonar-scanner/bin/sonar-scanner = scanner binary
                        # -Dsonar.projectKey = unique project ID
                        # -Dsonar.sources = folders to scan
                        # -Dsonar.sourceEncoding = UTF-8 encoding
                        /tmp/sonar-scanner/bin/sonar-scanner \
                          -Dsonar.projectKey=DevWeb-Clients \
                          -Dsonar.sources=. \
                          -Dsonar.sourceEncoding=UTF-8
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    script {
                        def qg = waitForQualityGate abortPipeline: true   // Fail if QG red
                        echo "Quality gate status: ${qg.status}"
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
    }
}
