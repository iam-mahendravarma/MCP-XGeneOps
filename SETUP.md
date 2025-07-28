# Setup Guide - AI Full-Stack Application

This guide will help you set up and run the complete AI-powered full-stack application.

## 🏗️ Architecture Overview

- **Frontend**: React + Tailwind CSS (Port 3000)
- **Backend**: NestJS API (Port 3001)
- **AI Service**: Python FastAPI (Port 8000)
- **Databases**: PostgreSQL (users) + MongoDB (content)
- **Reverse Proxy**: Nginx (Port 80)

## 📋 Prerequisites

Before starting, ensure you have the following installed:

- **Docker** (version 20.10+)
- **Docker Compose** (version 2.0+)
- **Git** (for cloning the repository)

### Installing Docker

#### macOS
```bash
# Using Homebrew
brew install --cask docker

# Or download from https://www.docker.com/products/docker-desktop
```

#### Ubuntu/Debian
```bash
# Update package index
sudo apt-get update

# Install prerequisites
sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## 🚀 Quick Start

### Option 1: Automated Setup (Recommended)

1. **Clone the repository** (if not already done):
   ```bash
   git clone <repository-url>
   cd AI-Project
   ```

2. **Run the startup script**:
   ```bash
   ./start.sh
   ```

This script will:
- Check for Docker installation
- Create necessary environment files
- Build and start all services
- Check service health
- Provide access URLs

### Option 2: Manual Setup

1. **Create environment files**:

   **Frontend** (`frontend/.env`):
   ```env
   REACT_APP_API_URL=http://localhost:3001
   REACT_APP_AI_SERVICE_URL=http://localhost:8000
   ```

   **Backend** (`backend/.env`):
   ```env
   DATABASE_URL=postgresql://postgres:password@postgres:5432/userdb
   MONGODB_URI=mongodb://mongo:27017/contentdb
   AI_SERVICE_URL=http://ai-service:8000
   JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
   NODE_ENV=development
   ```

   **AI Service** (`ai-service/.env`):
   ```env
   MONGODB_URI=mongodb://mongo:27017/contentdb
   ```

2. **Start the application**:
   ```bash
   docker-compose up --build -d
   ```

3. **Check service status**:
   ```bash
   docker-compose ps
   ```

## 🌐 Accessing the Application

Once all services are running, you can access:

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:3001
- **AI Service**: http://localhost:8000
- **Nginx Proxy**: http://localhost:80

## 📊 Monitoring and Logs

### View all logs:
```bash
docker-compose logs -f
```

### View specific service logs:
```bash
docker-compose logs -f frontend
docker-compose logs -f backend
docker-compose logs -f ai-service
```

### Check service health:
```bash
curl http://localhost:3000/health    # Frontend
curl http://localhost:3001/api/health # Backend
curl http://localhost:8000/health    # AI Service
```

## 🛠️ Development

### Running Services Individually

#### Frontend Development
```bash
cd frontend
npm install
npm start
```

#### Backend Development
```bash
cd backend
npm install
npm run start:dev
```

#### AI Service Development
```bash
cd ai-service
pip install -r requirements.txt
python app.py
```

### Database Access

#### PostgreSQL (User Accounts)
```bash
docker-compose exec postgres psql -U postgres -d userdb
```

#### MongoDB (Content)
```bash
docker-compose exec mongo mongosh contentdb
```

## 🔧 Configuration

### Environment Variables

Key environment variables you can customize:

- `JWT_SECRET`: Secret key for JWT tokens
- `DATABASE_URL`: PostgreSQL connection string
- `MONGODB_URI`: MongoDB connection string
- `NODE_ENV`: Environment mode (development/production)

### Port Configuration

To change default ports, modify `docker-compose.yml`:

```yaml
ports:
  - "YOUR_PORT:3000"  # Frontend
  - "YOUR_PORT:3001"  # Backend
  - "YOUR_PORT:8000"  # AI Service
```

## 🐛 Troubleshooting

### Common Issues

1. **Port already in use**:
   ```bash
   # Check what's using the port
   lsof -i :3000
   lsof -i :3001
   lsof -i :8000
   
   # Kill the process or change ports in docker-compose.yml
   ```

2. **Docker daemon not running**:
   ```bash
   # Start Docker Desktop or Docker daemon
   sudo systemctl start docker  # Linux
   # Or open Docker Desktop on macOS/Windows
   ```

3. **Permission denied**:
   ```bash
   # Add user to docker group (Linux)
   sudo usermod -aG docker $USER
   # Log out and log back in
   ```

4. **Services not starting**:
   ```bash
   # Check logs
   docker-compose logs
   
   # Restart services
   docker-compose down
   docker-compose up --build
   ```

### Reset Everything

To completely reset the application:

```bash
# Stop and remove all containers, networks, and volumes
docker-compose down -v

# Remove all images
docker-compose down --rmi all

# Start fresh
./start.sh
```

## 📚 API Documentation

### Backend API Endpoints

- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `GET /api/auth/me` - Get current user
- `GET /api/dashboard/stats` - Dashboard statistics
- `GET /api/dashboard/recent-content` - Recent content
- `GET /api/content` - Get user content
- `POST /api/content` - Create content

### AI Service Endpoints

- `POST /ai/process` - Process text with AI
- `GET /ai/models` - Get available AI models
- `GET /ai/health` - Service health check

## 🔒 Security Notes

- Change the `JWT_SECRET` in production
- Use strong passwords for databases
- Enable HTTPS in production
- Regularly update dependencies
- Monitor logs for security issues

## 📈 Production Deployment

For production deployment:

1. Set `NODE_ENV=production`
2. Use proper SSL certificates
3. Configure proper database credentials
4. Set up monitoring and logging
5. Use a production-grade reverse proxy
6. Implement rate limiting
7. Set up backup strategies

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License. 