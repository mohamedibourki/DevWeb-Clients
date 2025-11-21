#!/bin/bash
echo "=== SonarQube Scanner ==="

# Display environment information
echo "🔧 Environment:"
echo "   Project: ${SONAR_PROJECT_NAME:-Not set}"
echo "   Build: ${BUILD_VERSION:-Not set}"
echo "   SonarQube: ${SONAR_HOST_URL:-Not set}"

# In CI, fail fast if SONAR_HOST_URL points to localhost
if [ -n "${GITHUB_ACTIONS:-}" ] || [ -n "${CI:-}" ]; then
    if [[ "${SONAR_HOST_URL:-}" =~ ^(http://)?(localhost|127\.0\.0\.1) ]]; then
        echo "❌ ERROR: SONAR_HOST_URL is set to localhost (${SONAR_HOST_URL})."
        echo "GitHub Actions runners cannot reach services on your local machine."
        echo "Set the secret SONAR_HOST_URL to a publicly accessible SonarQube or use SonarCloud."
        exit 1
    fi
fi

# Try to fallback to sonar-project.properties if SONAR_PROJECT_KEY not set
if [ -z "$SONAR_PROJECT_KEY" ] && [ -f sonar-project.properties ]; then
    KEY_LINE=$(grep -E '^sonar.projectKey=' sonar-project.properties || true)
    if [ -n "$KEY_LINE" ]; then
        SONAR_PROJECT_KEY=$(echo "$KEY_LINE" | cut -d'=' -f2-)
        echo "ℹ️  Fallback: using sonar.projectKey from sonar-project.properties -> $SONAR_PROJECT_KEY"
    fi
fi

# Check if required environment variables are set
if [ -z "$SONAR_PROJECT_KEY" ]; then
    echo "❌ ERROR: SONAR_PROJECT_KEY is not set"
    exit 1
fi

if [ -z "$SONAR_HOST_URL" ]; then
    echo "❌ ERROR: SONAR_HOST_URL is not set"
    exit 1
fi

echo "🔍 Running SonarQube analysis..."

# Build scanner command and include sonar.login if SONAR_TOKEN is provided
SCANNER_CMD="sonar-scanner \
  -Dsonar.projectKey=\"$SONAR_PROJECT_KEY\" \
  -Dsonar.projectName=\"$SONAR_PROJECT_NAME\" \
  -Dsonar.projectVersion=\"$BUILD_VERSION\" \
  -Dsonar.host.url=\"$SONAR_HOST_URL\" \
  -Dsonar.sources=. \
  -Dsonar.sourceEncoding=UTF-8"

if [ -n "$SONAR_TOKEN" ]; then
    SCANNER_CMD="$SCANNER_CMD -Dsonar.login=\"$SONAR_TOKEN\""
fi

# Execute
eval $SCANNER_CMD

# Check the result
EXIT_CODE=$?
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ SonarQube analysis completed successfully"
else
    echo "❌ SonarQube analysis failed with exit code: $EXIT_CODE"
    exit $EXIT_CODE
fi