.PHONY: build deploy invoke

APP_DIR    := ../app
LAMBDA_ZIP := $(APP_DIR)/target/function.zip

build:
	cd $(APP_DIR) && mvn package -DskipTests -Plambda,native -Dquarkus.native.container-build=true

deploy: build
	lambroll deploy --src=$(LAMBDA_ZIP)

invoke:
	lambroll invoke --log-tail < /dev/null
