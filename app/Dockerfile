# Stage 1: build
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .

# Stage 2: final runtime - small, non-root
FROM node:18-alpine AS runtime
# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
# Copy built artifacts
COPY --from=build /app /app
# ensure permissions
RUN chown -R appuser:appgroup /app
USER appuser

# Reduce capabilities by default (runtime requirement)
ENV NODE_ENV=production
EXPOSE 3000
CMD ["node", "index.js"]
