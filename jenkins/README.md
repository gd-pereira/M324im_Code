# Jenkins setup

## Local (Docker/Colima) – http://localhost:8080
    ./run-local.sh
Installs plugins (pipeline, git, nodejs, docker-workflow), a `node` tool and the
`trafficlight` pipeline job (script = `Jenkinsfile`; repo mounted at /repo).
Unlock: `docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword`
To use GitHub instead: set `REPO_URL` in `Jenkinsfile`, re-run `run-local.sh`.

## AWS EC2 (Jenkins + Docker-in-Docker)
1. `cd aws && cp aws.conf.example aws.conf` (set PRIVATE_KEY, DEST) and run `./04_scp.sh`
2. On EC2 (Docker installed): `cd ~/jenkins && export DOCKERHUB_USER=<you> && ./02_setup.sh && ./03_run.sh`
3. Password: `docker exec jenkins_dind cat /root/.jenkins/secrets/initialAdminPassword`
4. From the Mac: `ssh -i <key> -L 8084:localhost:8083 <user@host>` -> http://localhost:8084
