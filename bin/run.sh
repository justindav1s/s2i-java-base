#!/usr/bin/env bash

s2i build https://github.com/justindav1s/simple-java-service s2i-java-base simple-springboot-app

docker run -p 8080:8080 springboot-sample-app