.PHONY: usage clean build prod

TARGET := $(or $(TARGET), production)

usage:
	@echo "usage: make [clean|build|push]"
	@echo "usage: make build"

clean:
	-docker rmi --force umedia-rails:latest

build:
	docker build --no-cache --target $(TARGET) --progress=plain -t umedia-rails:latest .
	@echo "docker run --rm -it umedia-rails:latest /bin/bash"

