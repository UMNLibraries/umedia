.PHONY: usage clean build prod

TARGET := $(or $(TARGET), production)
VERSION := $(shell cat version.txt)

usage:
	@echo "Current image version: ${VERSION}"
	@echo "usage: make [clean|build|push]"

clean:
	-docker rmi --force umedia-rails:latest

build:
	docker build --no-cache --target $(TARGET) --progress=plain -t umedia-rails:$(VERSION) .
	@echo "docker run --rm -it umedia-rails:$(VERSION) /bin/bash"

tags:
	docker tag umedia-rails:$(VERSION) umedia-rails:latest
	docker tag umedia-rails:$(VERSION) umedia.azurecr.io/umedia-rails:$(VERSION)
	docker tag umedia-rails:$(VERSION) umedia.azurecr.io/umedia-rails:latest

push:
	docker push --all-tags umedia.azurecr.io/umedia-rails

