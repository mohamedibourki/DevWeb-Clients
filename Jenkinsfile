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
        
        stage('Wait for Analysis Processing') {
            steps {
                script {
                    // Wait for analysis to complete processing
                    echo "Waiting for SonarQube to process analysis..."
                    sleep time: 30, unit: 'SECONDS'
                }
            }
        }
        
        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    script {
                        // Retry logic for Quality Gate
                        def maxRetries = 6
                        def retryCount = 0
                        def qg = null
                        
                        while (retryCount < maxRetries) {
                            try {
                                qg = waitForQualityGate abortPipeline: false
                                echo "Quality Gate status: ${qg.status}"
                                
                                if (qg.status == 'OK' || qg.status == 'ERROR') {
                                    break
                                }
                                
                                if (qg.status == 'IN_PROGRESS' || qg.status == 'PENDING') {
                                    retryCount++
                                    echo "Analysis still processing. Retry ${retryCount}/${maxRetries}. Waiting 30 seconds..."
                                    sleep time: 30, unit: 'SECONDS'
                                }
                            } catch (Exception e) {
                                echo "Error checking Quality Gate: ${e.message}. Retrying..."
                                retryCount++
                                sleep time: 30, unit: 'SECONDS'
                            }
                        }
                        
                        if (qg?.status != 'OK') {
                            error "Quality Gate failed: ${qg?.status ?: 'Unknown status'}"
                        }
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