# Use a modern, stable Node.js runtime
FROM node:20-slim AS builder

WORKDIR /app

# If you cloned the repository directly:
# Ensure you cloned with `--recursive` as it contains submodules
COPY . .

# Install dependencies and build the TypeScript SDK
RUN npm install
RUN npm run build

# --- Production Stage ---
FROM node:20-slim

WORKDIR /app

# Copy built files and package manifests
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

# Install only production dependencies
RUN npm prune --production

# Expose the internal port your app/script listens on
EXPOSE 8080

# Environment variables
ENV PORT=8080
ENV NODE_ENV=production

# Command to execute your service or entrypoint script
CMD [ "node", "dist/index.js" ]

