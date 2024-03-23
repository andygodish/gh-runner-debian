#!/bin/bash

# Attempt to run a simple Docker command.
docker info > /dev/null 2>&1

# Check the exit code of the Docker command.
if [ $? -eq 0 ]; then
    # Docker is running.
    exit 0
else
    # Docker is not running.
    exit 1
fi

