#!/bin/bash

docker build -t spark_cluster:local -f docker/Dockerfile --no-cache .
