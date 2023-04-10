
-include .env
export $(shell test -f .env && cut -d= -f1 .env)

## ======
## Server
## ======

server-ps:
	cd server && docker compose ps

server-nextcloud-log:
	cd server && docker compose logs -f nextcloud

server-mysql-log:
	cd server && docker compose logs -f mysql

server-restart:
	@cd server && docker compose up -d

server-reset:
	@sudo rm -fr server/var/mysql server/var/nextcloud
	@mkdir -p server/var/mysql server/var/nextcloud

server-ssh:
	@sshpass -p $${SERVER_PASSWORD} ssh $${SERVER_USER}@${SERVER_HOST} -p $${SERVER_PORT:-22} bash -s -- $${SERVER_PASSWORD}

## ======
## Deploy
## ======

deploy-server:
	@date > server/RELEASE
	@git add .
	@git commit -am "Deploy"
	@git push
	@cat server/scripts/deploy.sh | make -s server-ssh

## ====
## Test
## ====

test-server-nextcloud:
	@cd server && docker compose up -d --build --force-recreate nextcloud collabora mysql adminer
	@echo "Visit: <http://localhost:9999>"
