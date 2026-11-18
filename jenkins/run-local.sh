#!/bin/bash
# Recreates the local Jenkins container with plugins, node tool and the
# "trafficlight" pipeline job. Data stays in ~/jenkins_home.
set -euo pipefail
cd "$(dirname "$0")"
HERE="$PWD"
REPO="$(dirname "$HERE")"
HOME_DIR="$HOME/jenkins_home"

docker rm -f jenkins >/dev/null 2>&1 || true
docker run -d --name jenkins --restart unless-stopped \
  -p 8080:8080 -p 50000:50000 \
  -v "$HOME_DIR":/var/jenkins_home \
  -v "$REPO":/repo:ro \
  -v "$HERE/init.groovy.d":/var/jenkins_home/init.groovy.d:ro \
  -v "$HERE/plugins.txt":/plugins.txt:ro \
  jenkins/jenkins:lts

echo "Installing plugins (1-3 min)..."
docker exec jenkins jenkins-plugin-cli --plugin-file /plugins.txt \
  --plugin-download-directory /var/jenkins_home/plugins
docker restart jenkins >/dev/null

echo "Waiting for Jenkins on http://localhost:8080 ..."
until curl -s -o /dev/null http://localhost:8080/login; do sleep 3; done
echo "Up. First-time unlock password:"
echo "  docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword"
