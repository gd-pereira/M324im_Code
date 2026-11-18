#!/usr/bin/bash
# Set your Docker Hub user: export DOCKERHUB_USER=<name> or edit below.
user="${DOCKERHUB_USER:-CHANGE_ME}"

file1="Dockerfile1"; container1="jenkins1"; image1="${user}/jenkins1"
file2="Dockerfile2"; container2="jenkins2"; image2="${user}/jenkins2"
file3="Dockerfile3"; container3="jenkins_dind"; image3="${user}/jenkins_dind"
