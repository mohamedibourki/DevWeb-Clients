#!/bin/bash
echo "Installing SonarScanner..."

# Download and install SonarScanner
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-linux.zip
unzip sonar-scanner-cli-4.8.0.2856-linux.zip
export PATH=$PWD/sonar-scanner-4.8.0.2856-linux/bin:$PATH

echo "Running SonarScanner analysis..."
sonar-scanner \
  -Dsonar.projectKey=DevWeb-Clients \
  -Dsonar.sources=. \
  -Dsonar.host.url=${SONAR_HOST_URL} \
  -Dsonar.login=${SONAR_TOKEN}

echo "Analysis complete!"