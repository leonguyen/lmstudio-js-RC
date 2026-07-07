# Use a modern, slim Node image
FROM node:20-slim AS builder

WORKDIR /app

# Copy package management files
COPY package*.json ./

# Install all dependencies
RUN npm ci

# Copy the rest of the source code
COPY . .

# Build the TypeScript or production assets if applicable
RUN npm run build --if-present

# Production stage
FROM node:20-slim

WORKDIR /app

ENV NODE_ENV=production

# Copy built artifacts and production dependencies
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

# Expose the application port
EXPOSE 3000

# Start command
CMD ["node", "dist/index.js"]

