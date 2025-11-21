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
        
        stage('Install SonarScanner') {
            steps {
                script {
                    sh '''
                        if [ ! -f "/tmp/sonar-scanner/bin/sonar-scanner" ]; then
                            echo "Installing SonarScanner..."
                            cd /tmp
                            wget -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006.zip
                            unzip -q sonar-scanner-cli-5.0.1.3006.zip
                            mv sonar-scanner-5.0.1.3006 sonar-scanner
                            echo "SonarScanner installed successfully"
                        else
                            echo "SonarScanner already installed"
                        fi
                    '''
                }
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
                        -Dsonar.host.url=http://localhost:9000 \
                        -Dsonar.login=$SONAR_TOKEN \
                        -Dsonar.projectVersion=1.0 \
                        -Dsonar.sourceEncoding=UTF-8
                    '''
                }
            }
        }
        
        stage('Quality Gate') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
    
    post {
        always {
            echo 'SonarQube analysis completed'
        }
    }
}