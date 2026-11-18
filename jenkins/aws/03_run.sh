#!/usr/bin/bash
# Runs jenkins_dind on the EC2 instance and starts dockerd + jenkins inside it.
PARAMS='01_params.sh'
if [ ! -f "$PARAMS" ]; then echo "$PARAMS does not exist!"; exit 1; fi
source "$PARAMS"

docker rm -f "$container3" 2>/dev/null
# remove old jenkins_home on the host so a fresh admin password is generated
if [ -d "$HOME/jenkins_home" ]; then sudo rm -rf "$HOME/jenkins_home"; fi
mkdir -p "$HOME/jenkins_home"

echo "run now $container3"
docker run -itd --privileged --name "$container3" \
  -p 8083:8080 -v "$HOME/jenkins_home":/root/.jenkins "$image3" bash

docker exec -d "$container3" dockerd
sleep 8
docker exec -d "$container3" jenkins
echo "Wait ~60s, then: docker exec $container3 cat /root/.jenkins/secrets/initialAdminPassword"
echo "Open from your Mac: ssh -i <key> -L 8084:localhost:8083 <user@ec2-host>  ->  http://localhost:8084"
