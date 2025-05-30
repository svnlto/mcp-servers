# MCP Multiverse Makefile
.PHONY: help start stop restart status logs build clean setup check-env

# Default target
help: ## Show this help message
	@echo "MCP Multiverse Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

setup: ## Copy .env.example to .env if it doesn't exist
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "✅ Created .env from .env.example"; \
		echo "⚠️  Please edit .env with your API tokens"; \
	else \
		echo "ℹ️  .env already exists"; \
	fi

check-env: ## Check if .env file exists and has required variables
	@if [ ! -f .env ]; then \
		echo "❌ .env file not found. Run 'make setup' first."; \
		exit 1; \
	fi
	@echo "✅ .env file exists"

start: check-env ## Start the MCP multiverse container
	@echo "🚀 Starting MCP Multiverse..."
	docker-compose up -d
	@echo "✅ Services started"

stop: ## Stop the MCP multiverse container
	@echo "🛑 Stopping MCP Multiverse..."
	docker-compose down
	@echo "✅ Services stopped"

restart: ## Restart the MCP multiverse container
	@echo "🔄 Restarting MCP Multiverse..."
	docker-compose restart
	@echo "✅ Services restarted"

status: ## Show status of containers
	@echo "📊 Container Status:"
	docker-compose ps

logs: ## Show logs from the multiverse container
	docker-compose logs -f multiverse

logs-tail: ## Show last 50 lines of logs
	docker-compose logs --tail=50 multiverse

build: ## Build/rebuild the container
	@echo "🔨 Building containers..."
	docker-compose build
	@echo "✅ Build complete"

clean: ## Stop containers and remove volumes
	@echo "🧹 Cleaning up..."
	docker-compose down -v
	docker system prune -f
	@echo "✅ Cleanup complete"

shell: ## Open a shell in the multiverse container
	docker-compose exec multiverse sh

config: ## Validate docker-compose configuration
	docker-compose config

update: ## Pull latest images and restart
	@echo "⬇️  Pulling latest images..."
	docker-compose pull
	$(MAKE) restart
	@echo "✅ Update complete"

dev: start logs ## Start services and follow logs (for development)

install: setup start ## Full setup: copy env, start services
	@echo ""
	@echo "🎉 MCP Multiverse is ready!"
	@echo ""
	@echo "📝 Next steps:"
	@echo "  1. Edit .env with your API tokens"
	@echo "  2. Run 'make restart' after updating .env"
	@echo "  3. Configure your editors with configs from ./configs/"
	@echo ""
