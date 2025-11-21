# DevWeb-Clients

## CI / SonarQube notes

- The GitHub Actions workflow requires these repository secrets:
  - SONAR_HOST_URL — URL of your SonarQube or SonarCloud server (must be reachable from GitHub runners).
  - SONAR_TOKEN — token (Secret) for authentication.
  - SONAR_PROJECT_KEY — optional override for the project key.

- If you run SonarQube on your local machine (http://localhost:9000), GitHub Actions cannot reach it. Set the secrets to a publicly reachable Sonar instance or use SonarCloud.

- To avoid failing pushes when Sonar is not reachable, the workflow will skip the Sonar scan and continue the job, printing a warning. To enable scanning, provide reachable SONAR_HOST_URL and SONAR_TOKEN in repository secrets.
