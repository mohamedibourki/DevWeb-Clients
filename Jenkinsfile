pipeline {
    agent any
    
    environment {
        // Set directly in Jenkins (more secure)
        SONAR_HOST_URL = 'http://localhost:9000'
        SONAR_PROJECT_KEY = 'DevWeb-Clients'
        SONAR_PROJECT_NAME = 'Portail Clients DevWeb'
        BUILD_VERSION = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Environment Setup') {
            steps {
                script {
                    // Create .env for local tooling if needed
                    sh '''
                        cat > .env << EOF
                        # Auto-generated for local tools
                        SONAR_HOST_URL=${SONAR_HOST_URL}
                        SONAR_PROJECT_KEY=${SONAR_PROJECT_KEY}
                        BUILD_VERSION=${BUILD_VERSION}
                        NODE_ENV=ci
                        EOF
                    '''
                }
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                // Ensure a SonarQube server is configured in Jenkins with the name 'sonar-server'
                withSonarQubeEnv('sonar-server') {
                    // Bind the Sonar token from Jenkins credentials (create a 'Secret text' credential)
                    withCredentials([string(credentialsId: 'SONAR_TOKEN_CREDENTIAL_ID', variable: 'SONAR_TOKEN')]) {
                        sh '''
                            echo "Using environment (project key only, token hidden)"
                            echo "Project: $SONAR_PROJECT_KEY"
                            echo "URL: $SONAR_HOST_URL"
                            
                            # Run analysis using Jenkins environment variables and token
                            sonar-scanner \
                              -Dsonar.projectKey=$SONAR_PROJECT_KEY \
                              -Dsonar.projectName="$SONAR_PROJECT_NAME" \
                              -Dsonar.host.url=$SONAR_HOST_URL \
                              -Dsonar.projectVersion=$BUILD_VERSION \
                              -Dsonar.sources=. \
                              -Dsonar.login=$SONAR_TOKEN
                        '''
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                // Wait for Quality Gate result and fail the build if not OK
                timeout(time: 5, unit: 'MINUTES') {
                    script {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }
    }
}