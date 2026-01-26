TARGET := $(or $(TARGET), production)
VERSION := $(shell cat version.txt)

.PHONY: usage
usage:
	@echo "Current image version: ${VERSION}"
	@echo "usage: make [clean|build|tags|push]"

.PHONY: clean
clean:
	-docker rmi --force umedia-rails:latest

.PHONY: build
build:
	docker build --no-cache --target $(TARGET) --progress=plain --tag umedia-rails:$(VERSION) --platform 'linux/amd64,linux/arm64' .
	@echo "\n\ndocker run --rm -it umedia-rails:$(VERSION) /bin/bash"

.PHONY: tags
tags:
	docker tag umedia-rails:$(VERSION) umedia-rails:latest
	docker tag umedia-rails:$(VERSION) ghcr.io/umnlibraries/umedia-rails:$(VERSION)
	docker tag umedia-rails:$(VERSION) ghcr.io/umnlibraries/umedia-rails:latest

.PHONY: push
push:
	docker push ghcr.io/umnlibraries/umedia-rails:$(VERSION)
	docker push ghcr.io/umnlibraries/umedia-rails:latest
	@echo "https://github.com/UMNLibraries/umedia/pkgs/container/umedia-rails"
