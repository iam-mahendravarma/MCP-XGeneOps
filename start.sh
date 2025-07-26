#!/bin/bash

echo "🚀 Starting AI Full-Stack Application..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
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

# Build and start services
echo "🔨 Building and starting services..."
docker-compose up --build -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 30

# Check service health
echo "🏥 Checking service health..."

# Check frontend
if curl -f http://localhost:3000/health &> /dev/null; then
    echo "✅ Frontend is running at http://localhost:3000"
else
    echo "⚠️  Frontend might still be starting up..."
fi

# Check backend
if curl -f http://localhost:3001/api/health &> /dev/null; then
    echo "✅ Backend API is running at http://localhost:3001"
else
    echo "⚠️  Backend might still be starting up..."
fi

# Check AI service
if curl -f http://localhost:8000/health &> /dev/null; then
    echo "✅ AI Service is running at http://localhost:8000"
else
    echo "⚠️  AI Service might still be starting up..."
fi

echo ""
echo "🎉 Application is starting up!"
echo ""
echo "📱 Access your application:"
echo "   Frontend: http://localhost:3000"
echo "   Backend API: http://localhost:3001"
echo "   AI Service: http://localhost:8000"
echo ""
echo "📊 Monitor services:"
echo "   docker-compose logs -f"
echo ""
echo "🛑 To stop the application:"
echo "   docker-compose down"
echo ""
echo "🔄 To restart:"
echo "   docker-compose restart" 