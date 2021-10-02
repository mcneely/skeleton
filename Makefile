RUN_CONTAINER = apache
#RUN_CONTAINER = nginx
RUN_CMD = docker-compose run --no-deps $(RUN_CONTAINER)

install-hook:
	cp app/scripts/pre-commit .git/hooks/pre-commit
	chmod 0777 .git/hooks/pre-commit
.PHONY:install-hook

copy:
	cp docker-compose.override.dist.yml docker-compose.override.yml
	cp .env.dist .env
.PHONY: copy

init: copy build
.PHONY: init

## DEVELOPMENT ##
docker-build:
	docker-compose build
.PHONY: docker-build

build: docker-build yarn-install
.PHONY: build

start:
	docker-compose up -d
.PHONY: start

stop:
	docker-compose down
.PHONY: stop

yarn-install:
	$(RUN_CMD) yarn install
	$(RUN_CMD) yarn build
.PHONY: yarn-install

watch:
	$(RUN_CMD) yarn watch
.PHONY: watch

pull:
	git pull
.PHONY: pull

lint:
#Linting Placeholder
.PHONY: lint

test:
#Test Placeholder
.PHONY: test

## PRODUCTION ##

prod-yarn-install: yarn-install
	$(RUN_CMD) yarn install --production
.PHONY: prod-yarn-install

prod-deploy: pull prod-yarn-install
.PHONY: deploy

docker-prod-build:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml build
.PHONY: docker-prod-build

prod-build: pull docker-prod-build
.PHONY: prod-build

prod-start:
	docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
.PHONY: prod-start

prod-stop:
	prod-down": "docker-compose -f docker-compose.yml -f docker-compose.prod.yml down
.PHONY: prod-stop