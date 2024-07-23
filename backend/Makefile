START_LOG = @echo "================================================= START OF LOG ==================================================="
END_LOG = @echo "================================================== END OF LOG ===================================================="

.PHONY: env
env: ./.env.develop.tmpl
	$(START_LOG)
	@cp ./.env.develop.tmpl ./.env
	@echo "Environment file created at ./.env"
	$(END_LOG)

.PHONY: infra
infra:
	$(START_LOG)
	@docker compose \
		-f ../docker-compose.yml up \
		--build -d
	@echo "Creating kafka topics..."
	@sleep 30
	@docker compose \
		-f ../docker-compose.yml exec \
		kafka kafka-topics --bootstrap-server kafka:9094 \
		--create --topic orders \
		--partitions 10
	$(END_LOG)

.PHONY: down-infra
down-infra:
	$(START_LOG)
	@if [ "$(clean)" = "true" ]; then \
		docker compose \
		-f ../docker-compose.yml down \
		-v; \
	else \
		docker compose \
		-f ../docker-compose.yml down; \
	fi
	$(END_LOG)

.PHONY: run
run:
	$(START_LOG)
	@docker compose \
		-f ./deployments/compose.packages.yaml up \
		--build -d
	$(END_LOG)

.PHONY: swagger
swagger:
	$(START_LOG)
	@if command -v swag >/dev/null 2>&1; then \
		swag init -g ./cmd/server/main.go -o ./api; \
	else \
		docker run --rm -v $$(pwd):/code ghcr.io/swaggo/swag:latest init -g ./cmd/server/main.go -o ./api; \
	fi
	@go mod tidy
	$(END_LOG)

.PHONY: api
api:
	$(START_LOG)
	@if command -v swag >/dev/null 2>&1; then \
		swag init -g ./cmd/server/main.go -o ./api; \
	else \
		docker run --rm -v $$(pwd):/code ghcr.io/swaggo/swag:latest init -g ./cmd/server/main.go -o ./api; \
	fi
	@if [ $$? -ne 0 ]; then \
		echo "Error generating Swagger documentation"; \
		exit 1; \
	fi
	@go mod tidy
	go run ./cmd/server/main.go
	$(END_LOG)

.PHONY: redis
redis:
	$(START_LOG)
	@if [ "$(reset)" = "true" ]; then \
		docker compose -f ../docker-compose.yml down redis -v; \
	fi
	@docker compose -f ../docker-compose.yml up redis -d
	$(END_LOG)

.PHONY: db
db:
	$(START_LOG)
	@if [ "$(reset)" = "true" ]; then \
		docker compose -f ../docker-compose.yml down postgres -v; \
	fi
	@docker compose -f ../docker-compose.yml up postgres -d
	$(END_LOG)
