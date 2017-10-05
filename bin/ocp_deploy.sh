#!/usr/bin/env bash

USER=justin
PROJECT=boot-service
IMAGE=s2i-java-base
IMAGE_NAMESPACE=$PROJECT
REGISTRY_HOST=docker-registry-default.apps.192.168.140.152.xip.io

oc login -u $USER

oc delete project $PROJECT
oc new-project $PROJECT 2> /dev/null
while [ $? \> 0 ]; do
    oc new-project $PROJECT 2> /dev/null
done

docker build -t $IMAGE ..
docker tag $IMAGE $REGISTRY_HOST/$IMAGE_NAMESPACE/$IMAGE

TOKEN=`oc whoami -t`

docker login -p $TOKEN -u $USER $REGISTRY_HOST

sleep 3

docker push $REGISTRY_HOST/$IMAGE_NAMESPACE/$IMAGE

#oc new-app $PROJECT/$IMAGE~https://github.com/justindav1s/simple-java-service.git

#required if we want CI builds, we need to give jenkins access to project
#oc policy add-role-to-user edit system:serviceaccount:ci:jenkins -n $PROJECT

#oc create -f ../templates/java-base-s2i-ephemeral-template.yml
oc create -f ../templates/java-base-pipeline-ephemeral-template.yml
