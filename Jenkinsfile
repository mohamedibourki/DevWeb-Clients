pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('SONAR_TOKEN_CREDENTIAL_ID')
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh '''
                    /tmp/sonar-scanner/bin/sonar-scanner \
                        -Dsonar.projectKey=DevWeb-Clients \
                        -Dsonar.projectName="DevWeb Clients" \
                        -Dsonar.sources=. \
                        -Dsonar.projectVersion=1.0 \
                        -Dsonar.sourceEncoding=UTF-8
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    script {
                        def qg = waitForQualityGate abortPipeline: true
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
