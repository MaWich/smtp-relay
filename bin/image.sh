#!/bin/bash

# set -x
set -eo pipefail
WORKDIR=$(realpath $0 | xargs dirname | xargs dirname)

export FROM_IMAGE=${FROM_IMAGE:-alpine:3.10}
VERSION=${VERSION:-`cat $WORKDIR/VERSION`}
IMAGE_NAME=${IMAGE_NAME:-local/mawich/smtp-relay}
IMAGE_TAG=${IMAGE_TAG:-$VERSION}
IMAGE=${IMAGE:-"$IMAGE_NAME:$IMAGE_TAG"}

build_image() {
    envsubst '$FROM_IMAGE' < Dockerfile | docker build -t $* -f - ${WORKDIR}
}

dockerhub_push() {
    if [ -z $(docker image list -q ${IMAGE}) ]; then
        build_image "${IMAGE}-nobase" --build-arg "RUN_BUILD_BASE=false"
        build_image ${IMAGE}
        test_image ${IMAGE}
    fi
    
    docker login

    # push version tag
    docker push ${IMAGE}
}

case "$1" in
    build)
        build_image ${IMAGE}
        ;;
    publish)
        dockerhub_push

        # push latest tag
        docker tag ${IMAGE} ${IMAGE_NAME}:latest
        docker push ${IMAGE_NAME}:latest
        ;;
    *)
        echo "Usage $0 <build|publish>"
esac