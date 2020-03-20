NAME := samejack/backup
TAG := latest
IMAGE_NAME := $(NAME)

.PHONY: help build push clean

all:
	make build

help:
	@printf "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)\n"

build: ## Builds docker image latest
	docker build --pull -t $(IMAGE_NAME):latest .

push: ## Pushes the docker image to hub.docker.com
	docker build -t $(IMAGE_NAME):$(TAG) .
	docker tag $(IMAGE_NAME):$(TAG) $(IMAGE_NAME):latest
	docker push $(IMAGE_NAME):$(TAG)
	docker push $(IMAGE_NAME):latest

clean: ## Remove built images
	docker rmi $(IMAGE_NAME):latest
	docker rmi $(IMAGE_NAME):$(TAG)

