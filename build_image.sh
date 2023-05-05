#!/bin/bash 
docker build --no-cache \
	     -f Dockerfile \
 	     -t tutorgaming/pytorch-docker \
             .
