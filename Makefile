TARGET := $(or $(TARGET), dev)
VERSION := $(shell cat version.txt)

.PHONY: usage
usage:
	@echo "Current image version: ${VERSION}"
	@echo "usage: make [clean|build|tags|push]"

.PHONY: clean
clean:
	-docker rmi --force umedia-rails:latest

# for debug output, prepend environment variable DOCKER_BUILDKIT=0 to the make invocation
.PHONY: build
build:
	docker build --tag ghcr.io/umnlibraries/umedia-rails:$(VERSION) --platform 'linux/amd64' --platform 'linux/arm64' .
	docker tag ghcr.io/umnlibraries/umedia-rails:$(VERSION) ghcr.io/umnlibraries/umedia-rails:latest

.PHONY: push
push:
	docker push ghcr.io/umnlibraries/umedia-rails:$(VERSION)
	docker push ghcr.io/umnlibraries/umedia-rails:latest
	@echo "https://github.com/UMNLibraries/umedia/pkgs/container/umedia-rails"
