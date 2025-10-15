# Stage 1: build dependencies
FROM node:18-alpine AS build
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci --production=false
COPY . .

# Stage 2: production
FROM node:18-alpine AS run
# create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/server.js ./server.js
COPY --from=build /app/package.json ./package.json

# drop privileges - run as nonroot user
USER appuser
ENV PORT=3000
EXPOSE 3000
CMD ["node", "server.js"]
