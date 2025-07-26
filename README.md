# Full-Stack AI Application

A modern full-stack application with microservices architecture.

## Architecture Overview

- **Frontend**: React + Tailwind CSS (deployed via Nginx)
- **Backend Microservices**: 
  - Node.js (NestJS) - Main API service
  - Python (AI service) - AI/ML processing
- **Databases**: 
  - MongoDB - Content storage
  - PostgreSQL - User accounts and authentication

## Project Structure

```
├── frontend/                 # React + Tailwind CSS
├── backend/                  # NestJS API service
├── ai-service/              # Python AI service
├── nginx/                   # Nginx configuration
├── docker-compose.yml       # Docker orchestration
└── README.md               # This file
```

## Quick Start

1. **Prerequisites**
   - Docker and Docker Compose
   - Node.js 18+
   - Python 3.9+

2. **Start the entire stack**
   ```bash
   docker-compose up -d
   ```

3. **Access the application**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:3001
   - AI Service: http://localhost:8000

## Development

### Frontend Development
```bash
cd frontend
npm install
npm start
```

### Backend Development
```bash
cd backend
npm install
npm run start:dev
```

### AI Service Development
```bash
cd ai-service
pip install -r requirements.txt
python app.py
```

## Environment Variables

Create `.env` files in each service directory with appropriate configuration.

## Deployment

The application is containerized and ready for deployment with Docker Compose. 