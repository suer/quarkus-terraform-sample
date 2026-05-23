.PHONY: build deploy invoke

APP_DIR    := app
ZIP        := $(APP_DIR)/target/function.zip

build:
	cd $(APP_DIR) && mvn package -DskipTests

deploy: build
	lambroll deploy --src=$(ZIP)

invoke:
	lambroll invoke --log-tail < /dev/null
