FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Copy .env file if it exists
COPY .env* ./

# Build the application
RUN npm run build

# Production stage
FROM node:18-alpine

WORKDIR /app

# Install netcat for database connectivity check
RUN apk add --no-cache netcat-openbsd

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Copy built application
COPY --from=builder /app/dist ./dist

# Copy wait script
COPY wait-for-db.sh ./
RUN chmod +x wait-for-db.sh

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nestjs -u 1001

# Change ownership of the app directory
RUN chown -R nestjs:nodejs /app
USER nestjs

# Expose port
EXPOSE 3001

# Start the application with wait script
CMD ["./wait-for-db.sh"] 