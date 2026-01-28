# ---------- Build stage ----------
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies (for caching)
COPY package*.json ./
RUN npm ci --omit=dev

# Copy source
COPY src ./src

# ---------- Runtime stage ----------
FROM node:20-alpine

WORKDIR /app

# Create non-root user&group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy /app from builder
COPY --from=builder /app /app

# Use non-root user
USER appuser

EXPOSE 3000

CMD ["node", "src/server.js"]
