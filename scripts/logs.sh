#!/bin/bash

docker logs $(docker ps -q) --follow

