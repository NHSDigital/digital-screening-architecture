#!/bin/sh
docker run --rm -e JAVA_TOOL_OPTIONS=-XX:UseSVE=0 -p 8082:8080 -v ./:/usr/local/structurizr structurizr/lite
