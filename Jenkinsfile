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
                    // Check if sonar-scanner is installed, if not install it
                    sh '''
                        if ! command -v sonar-scanner &> /dev/null; then
                            echo "Installing SonarScanner..."
                            wget -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006.zip
                            unzip -q sonar-scanner-cli-5.0.1.3006.zip
                            export PATH=$PWD/sonar-scanner-5.0.1.3006/bin:$PATH
                            echo "SonarScanner installed successfully"
                        else
                            echo "SonarScanner is already installed"
                        fi
                    '''
                }
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh '''
                        # Use the installed sonar-scanner
                        sonar-scanner \
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
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
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
            echo 'Quality Gate failed or analysis failed'
        }
    }
}