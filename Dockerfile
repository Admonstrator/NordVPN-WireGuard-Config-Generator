FROM oven/bun:latest

RUN apt-get update && \
    apt-get install -y curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy local files
COPY . .

# Build Frontend
WORKDIR /app/web-version-V2/web-version-V2-Frontend
RUN bun install && bun run build

# Setup Backend with Frontend assets
WORKDIR /app/web-version-V2/web-version-V2-Backend
# Copy built frontend assets to backend public directory
RUN rm -rf public/* && \
    cp -r ../web-version-V2-Frontend/dist/* public/

RUN bun install && bun run build

EXPOSE 3000

ENV NODE_ENV=production

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

CMD ["bun", "start"]
