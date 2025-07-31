#!/bin/bash

# Harbor Registry Configuration
HARBOR_HOST="172.16.20.11:8443"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔧 Setting up Docker for Harbor Registry${NC}"
echo "Harbor Host: $HARBOR_HOST"
echo ""

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}⚠️  This script requires sudo privileges${NC}"
    echo "Run: sudo ./setup-harbor.sh"
    exit 1
fi

# Configure Docker for insecure registry
echo -e "${YELLOW}🔧 Configuring Docker for insecure registry...${NC}"
mkdir -p /etc/docker
echo '{"insecure-registries": ["172.16.20.11:8443"]}' > /etc/docker/daemon.json
echo -e "${GREEN}✅ Docker daemon configuration updated${NC}"

# Restart Docker daemon
echo -e "${YELLOW}🔄 Restarting Docker daemon...${NC}"
systemctl restart docker
sleep 5
echo -e "${GREEN}✅ Docker daemon restarted${NC}"

# Start Harbor services
echo -e "${YELLOW}🚀 Starting Harbor services...${NC}"
docker start harbor-jobservice nginx harbor-core redis harbor-portal registryctl harbor-db registry
echo -e "${GREEN}✅ Harbor services started${NC}"

# Wait for Harbor to be ready
echo -e "${YELLOW}⏳ Waiting for Harbor to be ready...${NC}"
sleep 30

# Check Harbor status
echo -e "${YELLOW}🏥 Checking Harbor status...${NC}"
if curl -f http://$HARBOR_HOST &> /dev/null; then
    echo -e "${GREEN}✅ Harbor is running at http://$HARBOR_HOST${NC}"
else
    echo -e "${YELLOW}⚠️  Harbor might still be starting up...${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Harbor setup completed!${NC}"
echo ""
echo -e "${YELLOW}📋 Next steps:${NC}"
echo "1. Login to Harbor:"
echo "   docker login $HARBOR_HOST"
echo ""
echo "2. Push images to Harbor:"
echo "   ./push-to-harbor.sh"
echo ""
echo "3. Start application with Harbor images:"
echo "   ./start-harbor.sh"
echo ""
echo -e "${YELLOW}📊 Monitor Harbor services:${NC}"
echo "   docker ps | grep harbor" 