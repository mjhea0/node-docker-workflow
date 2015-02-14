# Local setup

1. Install boot2docker
1. Install fig - `brew install fig`
1. Add application
1. Dockerfile
1. fig.yml

# Docker Hub (push vs pull)

## PUSH

```sh
$ docker login
$ docker ps
$ docker tag nodedockerworkflow_web mjhea0/node-docker-workflow
$ docker push mjhea0/node-docker-workflow
```

## PULL

1. Uncheck active
1. Create automated build on Docker Hub


# CI

1. Push to Github
1. circle.yml

# CD - part 1: docker hub pull

1. Add build trigger
1. Update circle.yml file
1. Push to github, after tests pass, new build is triggered

# CD - part 2: deploy to digital ocean

1. Push from docker hub after new build
1. docker-hook-listener
1. Profit

## Sample script

```
#!/usr/bin/env sh
docker pull mjhea0/flask-docker-workflow
fig build
fig up -d
```