#!/bin/bash
# Run on your Mac: copies the build scripts to the EC2 instance.
# Needs aws.conf (copy aws.conf.example): PRIVATE_KEY and DEST.
cd "$(dirname "$0")"
CONF='./aws.conf'
if [ ! -f $CONF ]; then echo "$CONF does not exist!"; exit 2; fi
source ${CONF}
DIR="~/jenkins"
ssh -i "${PRIVATE_KEY}" "${DEST}" "rm -rf ${DIR} && mkdir -p ${DIR}"
scp -r -i "${PRIVATE_KEY}" 0[1-3]*.sh Dockerfile? helpers "${DEST}:${DIR}"
ssh -i "${PRIVATE_KEY}" "${DEST}" "sed -i 's/\r$//' ${DIR}/*.sh ${DIR}/helpers/*.sh; chmod +x ${DIR}/*.sh ${DIR}/helpers/*.sh"
echo "On EC2: cd ~/jenkins && export DOCKERHUB_USER=<you> && ./02_setup.sh && ./03_run.sh"
