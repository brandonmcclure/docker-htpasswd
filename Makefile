ifeq ($(OS),Windows_NT)
	SHELL := pwsh.exe
else
	SHELL := pwsh
endif

.SHELLFLAGS := -NoProfile -Command

REGISTRY_NAME := 
REPOSITORY_NAME := bmcclure89/
IMAGE_NAME := docker-htpassword
TAG := :latest


PLATFORMS := linux/amd64,linux/arm64,linux/arm/v7

all: build_docker

getcommitid: 
	$(eval COMMITID = $(shell git log -1 --pretty=format:"%H"))

build_docker: getcommitid
	docker build -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(COMMITID) .

build_multiarch:
	docker buildx build -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) --platform $(PLATFORMS) .

run:
	docker run -d $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG)

package:
	$$PackageFileName = "$$("$(IMAGE_NAME)" -replace "/","_").tar"; docker save $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) -o $$PackageFileName

publish:
	docker login; docker push $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG); docker logout