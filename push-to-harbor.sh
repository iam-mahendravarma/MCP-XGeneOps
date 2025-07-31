#!/bin/bash

# Harbor Registry Configuration
HARBOR_HOST="172.16.20.11:8443"
HARBOR_PROJECT="mcpxgenops"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Pushing MCP-XGeneOps images to Harbor Registry${NC}"
echo "Harbor Host: $HARBOR_HOST"
echo "Project: $HARBOR_PROJECT"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

# Check if user is logged in to Harbor
if ! docker info | grep -q "Username"; then
    echo -e "${YELLOW}⚠️  You need to login to Harbor first.${NC}"
    echo "Run: docker login $HARBOR_HOST"
    exit 1
fi

# Get current timestamp for versioning
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
VERSION=${1:-$TIMESTAMP}

echo -e "${GREEN}📦 Building and pushing images with version: $VERSION${NC}"
echo ""

# Build and push Frontend
echo -e "${YELLOW}🔨 Building Frontend image...${NC}"
docker build -t $HARBOR_HOST/$HARBOR_PROJECT/frontend:$VERSION ./frontend
docker build -t $HARBOR_HOST/$HARBOR_PROJECT/frontend:latest ./frontend

echo -e "${YELLOW}📤 Pushing Frontend image...${NC}"
docker push $HARBOR_HOST/$HARBOR_PROJECT/frontend:$VERSION
docker push $HARBOR_HOST/$HARBOR_PROJECT/frontend:latest
echo -e "${GREEN}✅ Frontend image pushed successfully${NC}"
echo ""

# Build and push Backend
echo -e "${YELLOW}🔨 Building Backend image...${NC}"
docker build -t $HARBOR_HOST/$HARBOR_PROJECT/backend:$VERSION ./backend
docker build -t $HARBOR_HOST/$HARBOR_PROJECT/backend:latest ./backend

echo -e "${YELLOW}📤 Pushing Backend image...${NC}"
docker push $HARBOR_HOST/$HARBOR_PROJECT/backend:$VERSION
docker push $HARBOR_HOST/$HARBOR_PROJECT/backend:latest
echo -e "${GREEN}✅ Backend image pushed successfully${NC}"
echo ""

# Build and push AI Service
echo -e "${YELLOW}🔨 Building AI Service image...${NC}"
docker build -t $HARBOR_HOST/$HARBOR_PROJECT/ai-service:$VERSION ./ai-service
docker build -t $HARBOR_HOST/$HARBOR_PROJECT/ai-service:latest ./ai-service

echo -e "${YELLOW}📤 Pushing AI Service image...${NC}"
docker push $HARBOR_HOST/$HARBOR_PROJECT/ai-service:$VERSION
docker push $HARBOR_HOST/$HARBOR_PROJECT/ai-service:latest
echo -e "${GREEN}✅ AI Service image pushed successfully${NC}"
echo ""

# Tag and push PostgreSQL
echo -e "${YELLOW}📤 Tagging and pushing PostgreSQL image...${NC}"
docker pull postgres:15-alpine
docker tag postgres:15-alpine $HARBOR_HOST/$HARBOR_PROJECT/postgres:$VERSION
docker tag postgres:15-alpine $HARBOR_HOST/$HARBOR_PROJECT/postgres:latest
docker push $HARBOR_HOST/$HARBOR_PROJECT/postgres:$VERSION
docker push $HARBOR_HOST/$HARBOR_PROJECT/postgres:latest
echo -e "${GREEN}✅ PostgreSQL image pushed successfully${NC}"
echo ""

# Tag and push MongoDB
echo -e "${YELLOW}📤 Tagging and pushing MongoDB image...${NC}"
docker pull mongo:6
docker tag mongo:6 $HARBOR_HOST/$HARBOR_PROJECT/mongo:$VERSION
docker tag mongo:6 $HARBOR_HOST/$HARBOR_PROJECT/mongo:latest
docker push $HARBOR_HOST/$HARBOR_PROJECT/mongo:$VERSION
docker push $HARBOR_HOST/$HARBOR_PROJECT/mongo:latest
echo -e "${GREEN}✅ MongoDB image pushed successfully${NC}"
echo ""

# Tag and push Nginx
echo -e "${YELLOW}📤 Tagging and pushing Nginx image...${NC}"
docker pull nginx:alpine
docker tag nginx:alpine $HARBOR_HOST/$HARBOR_PROJECT/nginx:$VERSION
docker tag nginx:alpine $HARBOR_HOST/$HARBOR_PROJECT/nginx:latest
docker push $HARBOR_HOST/$HARBOR_PROJECT/nginx:$VERSION
docker push $HARBOR_HOST/$HARBOR_PROJECT/nginx:latest
echo -e "${GREEN}✅ Nginx image pushed successfully${NC}"
echo ""

echo -e "${GREEN}🎉 All images pushed successfully to Harbor!${NC}"
echo ""
echo -e "${YELLOW}📋 Image URLs:${NC}"
echo "Frontend: $HARBOR_HOST/$HARBOR_PROJECT/frontend:$VERSION"
echo "Backend: $HARBOR_HOST/$HARBOR_PROJECT/backend:$VERSION"
echo "AI Service: $HARBOR_HOST/$HARBOR_PROJECT/ai-service:$VERSION"
echo "PostgreSQL: $HARBOR_HOST/$HARBOR_PROJECT/postgres:$VERSION"
echo "MongoDB: $HARBOR_HOST/$HARBOR_PROJECT/mongo:$VERSION"
echo "Nginx: $HARBOR_HOST/$HARBOR_PROJECT/nginx:$VERSION"
echo ""
echo -e "${YELLOW}💡 To use these images in docker-compose, update your docker-compose.yml${NC}"
echo "Example:"
echo "  frontend:"
echo "    image: $HARBOR_HOST/$HARBOR_PROJECT/frontend:$VERSION"
echo "  postgres:"
echo "    image: $HARBOR_HOST/$HARBOR_PROJECT/postgres:$VERSION"
echo "  mongo:"
echo "    image: $HARBOR_HOST/$HARBOR_PROJECT/mongo:$VERSION"
echo ""
echo -e "${YELLOW}🔄 To push with a specific version, run:${NC}"
echo "  ./push-to-harbor.sh v1.0.0" 