include .env
export

export PROJECT_ROOT=$(shell pwd)

db-up:
	docker compose up -d db

db-down:
	docker compose down db

db-migrate:
	docker compose run --rm api bundle exec rake db:migrate

worker-up:
	docker compose up -d worker

worker-down:
	docker compose down worker

run:
	docker compose up -d

stop:
	docker compose down

test:
	docker compose run --rm -e RACK_ENV=test api bundle exec rspec