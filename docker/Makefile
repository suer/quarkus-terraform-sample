.PHONY: build docker

APP_DIR := ../app

build:
	cd $(APP_DIR) && mvn package -DskipTests -Pnative -Dquarkus.native.container-build=true

docker: build
	docker build -f Dockerfile.native -t quarkus-hello:latest $(APP_DIR)/
