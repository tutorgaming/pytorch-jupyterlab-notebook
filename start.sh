#!/bin/bash

# SETUP THE CODE / DATASET PATH
export HOST_WORKSPACE_PATH=${HOME}/Repository/workspace
export HOST_DATASET_PATH=${HOME}/Datasets

docker compose up -d --build
