#!/bin/bash
set -eE -o pipefail

# Configuration
PROJECT_NAME="Core HRMS"
BRANCH="staging"
IMAGE_NAME=""
COMPOSE_FILE="docker-compose.ghcr.yml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Error handler
on_error() {
  local exit_code=$?
  echo -e "${RED}❌ Deployment failed with exit code: $exit_code${NC}"
  exit $exit_code
}

trap 'on_error' ERR

# Success handler
on_success() {
  echo -e "${GREEN}✅ Deployment completed successfully!${NC}"
}

# Log function
log() {
  echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

# Check if required environment variables are set
check_env() {
  if [ -z "$GHCR_USERNAME" ] || [ -z "$GHCR_PAT" ]; then
    echo -e "${RED}❌ Error: GHCR_USERNAME and GHCR_PAT must be set${NC}"
    exit 1
  fi
}

# Main deployment process
main() {
  log "🚀 Starting deployment for $PROJECT_NAME (branch: $BRANCH)"

  # Check environment variables
  check_env

  # Step 1: Update git repository
  log "📥 Updating git repository..."
  git reset --hard HEAD
  git clean -fd
  git pull origin "$BRANCH" || {
    echo -e "${YELLOW}⚠️  Warning: Git pull failed, continuing with existing code...${NC}"
  }

  # Step 2: Login to container registry
  log "🔐 Logging in to GitHub Container Registry..."
  echo "$GHCR_PAT" | docker login ghcr.io -u "$GHCR_USERNAME" --password-stdin || {
    echo -e "${RED}❌ Failed to login to GHCR${NC}"
    exit 1
  }

  # Step 3: Pull latest images
  log "📦 Pulling latest Docker images..."
  docker compose -f "$COMPOSE_FILE" pull || {
    echo -e "${RED}❌ Failed to pull Docker images${NC}"
    exit 1
  }

  # Step 4: Start/update containers
  log "🚀 Starting/updating containers..."
  docker compose -f "$COMPOSE_FILE" up -d --remove-orphans || {
    echo -e "${RED}❌ Failed to start containers${NC}"
    exit 1
  }

  # Step 5: Wait for containers to be healthy
  log "⏳ Waiting for containers to be ready..."
  sleep 5

  # Step 6: Check container status
  log "🔍 Checking container status..."
  if docker compose -f "$COMPOSE_FILE" ps | grep -q "Up"; then
    echo -e "${GREEN}✅ Containers are running${NC}"
    docker compose -f "$COMPOSE_FILE" ps
  else
    echo -e "${RED}❌ Some containers failed to start${NC}"
    docker compose -f "$COMPOSE_FILE" ps
    exit 1
  fi

  # Step 7: Run database migrations
  log "🗄️  Running database migrations..."
  if docker compose -f "$COMPOSE_FILE" exec -T app php artisan migrate --force; then
    echo -e "${GREEN}✅ Migrations completed successfully${NC}"
  else
    echo -e "${YELLOW}⚠️  Warning: Migration failed or no migrations to run${NC}"
    # Don't exit on migration failure, as it might be expected in some cases
  fi

  # Step 8: Cleanup old images (optional)
  log "🧹 Cleaning up old Docker images..."
  docker image prune -f --filter "dangling=true" || true

  # Step 9: Show container logs (last 20 lines)
  log "📋 Recent container logs:"
  docker compose -f "$COMPOSE_FILE" logs --tail=20 || true

  # Success
  on_success
}

# Run main function
main
ß
