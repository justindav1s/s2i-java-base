#!/usr/bin/env bash

USER=justin
PROJECT=test
IMAGE=s2i-java-base
REGISTRY_HOST=docker-registry-default.apps.192.168.140.152.xip.io

oc login -u $USER

oc delete project $PROJECT
sleep 20
oc new-project $PROJECT

docker build -t $IMAGE ..
docker tag $IMAGE $REGISTRY_HOST/$PROJECT/$IMAGE

TOKEN=`oc whoami -t`

docker login -p $TOKEN -u $USER $REGISTRY_HOST

docker push $REGISTRY_HOST/$PROJECT/$IMAGE

#oc new-app $PROJECT/$IMAGE~https://github.com/justindav1s/simple-java-service.git
oc create -f ../templates/java-base-ephemeral-template.json

