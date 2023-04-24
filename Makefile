
-include .env
export $(shell test -f .env && cut -d= -f1 .env)

## ======
## Server
## ======

server-init: server-guacamole-init
	@echo "Server init: OK!"

server-up:
	cd server && docker compose up -d

server-ps:
	cd server && docker compose ps

server-nextcloud-log:
	cd server && docker compose logs -f nextcloud

server-guacamole-init:
	@cd server && \
		docker compose run --rm guacamole /opt/guacamole/bin/initdb.sh --mysql > initdb.sql && \
		docker compose exec -T mysql sh -c 'MYSQL_PWD=$$MYSQL_ROOT_PASSWORD mysql -u root -h 0.0.0.0 $$MYSQL_DATABASE' < initdb.sql || true && \
		rm initdb.sql

server-guacamole-log:
	cd server && docker compose logs -f guacamole

server-mysql-log:
	cd server && docker compose logs -f mysql

server-pull:
	@cd server && docker compose pull --include-deps -q

server-restart: server-pull
	@cd server && docker compose up -d --build --force-recreate

server-reset:
	@sudo rm -fr server/var/mysql server/var/nextcloud
	@mkdir -p server/var/mysql server/var/nextcloud

server-ssh:
	@sshpass -p $${SERVER_PASSWORD} ssh $${SERVER_USER}@${SERVER_HOST} -p $${SERVER_PORT:-22} bash -s -- $${SERVER_PASSWORD}

server-shell:
	@sshpass -p $${SERVER_PASSWORD} ssh $${SERVER_USER}@${SERVER_HOST} -p $${SERVER_PORT:-22}

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

test-server-guacamole:
	@cd server && docker compose up -d --build --force-recreate guacamole guacd
	@echo "Visit: <http://localhost:9970/guacamole/>"

test-server-backup: server-up
	@cd server && docker compose exec backup /usr/local/bin/backup.sh
