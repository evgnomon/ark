IMAGE ?= ark:local

.PHONY: build
build:
	docker build -t $(IMAGE) .
