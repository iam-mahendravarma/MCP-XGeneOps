# Harbor Registry Setup for MCP-XGeneOps

This guide explains how to set up Harbor registry and push Docker images to it.

## Prerequisites

- Docker and Docker Compose installed
- Harbor registry running at `172.16.20.11:8443`
- Sudo privileges for Docker daemon configuration

## Quick Setup

### 1. Configure Docker for Insecure Registry

```bash
# Run the setup script (requires sudo)
sudo ./setup-harbor.sh
```

This script will:
- Configure Docker daemon to allow insecure registries
- Restart Docker daemon
- Start Harbor services
- Verify Harbor is running

### 2. Login to Harbor

```bash
docker login 172.16.20.11:8443
# Enter your Harbor username and password
```

### 3. Push Images to Harbor

```bash
# Push all images with timestamp version
./push-to-harbor.sh

# Or push with specific version
./push-to-harbor.sh v1.0.0
```

### 4. Start Application with Harbor Images

```bash
./start-harbor.sh
```

## Manual Setup (if scripts don't work)

### 1. Configure Docker Daemon

```bash
sudo nano /etc/docker/daemon.json
```

Add this content:
```json
{
  "insecure-registries": ["172.16.20.11:8443"]
}
```

Restart Docker:
```bash
sudo systemctl restart docker
```

### 2. Start Harbor Services

```bash
docker start harbor-jobservice nginx harbor-core redis harbor-portal registryctl harbor-db registry
```

### 3. Login to Harbor

```bash
docker login 172.16.20.11:8443
```

## Images that will be pushed to Harbor

### Custom-built Images:
- `172.16.20.11:8443/mcpxgenops/frontend:latest`
- `172.16.20.11:8443/mcpxgenops/backend:latest`
- `172.16.20.11:8443/mcpxgenops/ai-service:latest`

### Tagged Official Images:
- `172.16.20.11:8443/mcpxgenops/postgres:latest`
- `172.16.20.11:8443/mcpxgenops/mongo:latest`
- `172.16.20.11:8443/mcpxgenops/nginx:latest`

## CI/CD Configuration

The GitHub Actions workflow will automatically:
1. Configure Docker for insecure registry
2. Login to Harbor
3. Build and push all images
4. Tag images with commit SHA and latest

### Required GitHub Secrets:
- `HARBOR_HOST`: `172.16.20.11:8443`
- `HARBOR_USERNAME`: Your Harbor username
- `HARBOR_PASSWORD`: Your Harbor password

## Troubleshooting

### Error: "context deadline exceeded"
This usually means Docker is trying to use HTTPS instead of HTTP.

**Solution:**
1. Ensure `/etc/docker/daemon.json` contains the insecure registry
2. Restart Docker daemon
3. Check Harbor is running: `docker ps | grep harbor`

### Error: "unauthorized"
This means you need to login to Harbor.

**Solution:**
```bash
docker login 172.16.20.11:8443
```

### Harbor services not starting
Check if Harbor containers exist and are stopped.

**Solution:**
```bash
docker ps -a | grep harbor
docker start harbor-jobservice nginx harbor-core redis harbor-portal registryctl harbor-db registry
```

## File Structure

- `setup-harbor.sh` - Initial Harbor setup and Docker configuration
- `push-to-harbor.sh` - Push all images to Harbor
- `start-harbor.sh` - Start application using Harbor images
- `docker-compose.harbor.yml` - Docker Compose file using Harbor images
- `.github/workflows/ci.yml` - CI/CD workflow for automatic image pushing

## Usage Examples

### Development Workflow:
```bash
# 1. Setup Harbor (first time only)
sudo ./setup-harbor.sh

# 2. Login to Harbor
docker login 172.16.20.11:8443

# 3. Push images after changes
./push-to-harbor.sh

# 4. Start application
./start-harbor.sh
```

### Production Deployment:
```bash
# Use specific version
./push-to-harbor.sh v1.2.3

# Start with specific version
# Edit docker-compose.harbor.yml to use specific tags
``` 