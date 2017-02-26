#! /bin/bash

docker stop alpineo; docker rm alpineo
docker build -t "alpineo" .
docker run -t -i -p 8080:80 -d --name alpineo alpineo
docker exec -i -t alpineo /bin/sh



