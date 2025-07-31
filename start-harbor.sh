#!/bin/bash

# Harbor Registry Configuration
HARBOR_HOST="172.16.20.11:8443"
HARBOR_PROJECT="mcpxgenops"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting MCP-XGeneOps from Harbor Registry${NC}"
echo "Harbor Host: $HARBOR_HOST"
echo "Project: $HARBOR_PROJECT"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not installed. Please install Docker Compose first.${NC}"
    exit 1
fi

# Configure Docker for insecure registry (if not already configured)
if ! grep -q "172.16.20.11:8443" /etc/docker/daemon.json 2>/dev/null; then
    echo -e "${YELLOW}🔧 Configuring Docker for insecure registry...${NC}"
    sudo mkdir -p /etc/docker
    echo '{"insecure-registries": ["172.16.20.11:8443"]}' | sudo tee /etc/docker/daemon.json
    sudo systemctl restart docker
    sleep 5
    echo -e "${GREEN}✅ Docker configured for insecure registry${NC}"
fi

# Check if user is logged in to Harbor
if ! docker info | grep -q "Username"; then
    echo -e "${YELLOW}⚠️  You need to login to Harbor first.${NC}"
    echo "Run: docker login $HARBOR_HOST"
    exit 1
fi

# Create .env files if they don't exist
echo "📝 Setting up environment files..."

# Frontend .env
if [ ! -f "frontend/.env" ]; then
    cat > frontend/.env << EOF
REACT_APP_API_URL=http://localhost:3001
REACT_APP_AI_SERVICE_URL=http://localhost:8000
EOF
    echo "✅ Created frontend/.env"
fi

# Backend .env
if [ ! -f "backend/.env" ]; then
    cat > backend/.env << EOF
DATABASE_URL=postgresql://postgres:password@postgres:5432/userdb
MONGODB_URI=mongodb://mongo:27017/contentdb
AI_SERVICE_URL=http://ai-service:8000
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
NODE_ENV=development
EOF
    echo "✅ Created backend/.env"
fi

# AI Service .env
if [ ! -f "ai-service/.env" ]; then
    cat > ai-service/.env << EOF
MONGODB_URI=mongodb://mongo:27017/contentdb
EOF
    echo "✅ Created ai-service/.env"
fi

# Pull latest images from Harbor
echo -e "${YELLOW}📥 Pulling latest images from Harbor...${NC}"
docker pull $HARBOR_HOST/$HARBOR_PROJECT/frontend:latest
docker pull $HARBOR_HOST/$HARBOR_PROJECT/backend:latest
docker pull $HARBOR_HOST/$HARBOR_PROJECT/ai-service:latest
docker pull $HARBOR_HOST/$HARBOR_PROJECT/postgres:latest
docker pull $HARBOR_HOST/$HARBOR_PROJECT/mongo:latest
docker pull $HARBOR_HOST/$HARBOR_PROJECT/nginx:latest

# Start services using Harbor images
echo -e "${YELLOW}🚀 Starting services with Harbor images...${NC}"
docker-compose -f docker-compose.harbor.yml up -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 30

# Check service health
echo "🏥 Checking service health..."

# Check frontend
if curl -f http://localhost:3000/health &> /dev/null; then
    echo -e "${GREEN}✅ Frontend is running at http://localhost:3000${NC}"
else
    echo -e "${YELLOW}⚠️  Frontend might still be starting up...${NC}"
fi

# Check backend
if curl -f http://localhost:3001/api/health &> /dev/null; then
    echo -e "${GREEN}✅ Backend API is running at http://localhost:3001${NC}"
else
    echo -e "${YELLOW}⚠️  Backend might still be starting up...${NC}"
fi

# Check AI service
if curl -f http://localhost:8000/health &> /dev/null; then
    echo -e "${GREEN}✅ AI Service is running at http://localhost:8000${NC}"
else
    echo -e "${YELLOW}⚠️  AI Service might still be starting up...${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Application is starting up with Harbor images!${NC}"
echo ""
echo "📱 Access your application:"
echo "   Frontend: http://localhost:3000"
echo "   Backend API: http://localhost:3001"
echo "   AI Service: http://localhost:8000"
echo ""
echo "📊 Monitor services:"
echo "   docker-compose -f docker-compose.harbor.yml logs -f"
echo ""
echo "🛑 To stop the application:"
echo "   docker-compose -f docker-compose.harbor.yml down"
echo ""
echo "🔄 To restart:"
echo "   docker-compose -f docker-compose.harbor.yml restart"
echo ""
echo -e "${YELLOW}📋 Harbor Images Used:${NC}"
echo "   Frontend: $HARBOR_HOST/$HARBOR_PROJECT/frontend:latest"
echo "   Backend: $HARBOR_HOST/$HARBOR_PROJECT/backend:latest"
echo "   AI Service: $HARBOR_HOST/$HARBOR_PROJECT/ai-service:latest"
echo "   PostgreSQL: $HARBOR_HOST/$HARBOR_PROJECT/postgres:latest"
echo "   MongoDB: $HARBOR_HOST/$HARBOR_PROJECT/mongo:latest"
echo "   Nginx: $HARBOR_HOST/$HARBOR_PROJECT/nginx:latest" 