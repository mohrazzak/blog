# Use a specific node version for consistency
FROM node:18-slim

# Set working directory
WORKDIR /usr/blog

# Install system dependencies for native modules
RUN apt-get update && \
    apt-get install -y python3 build-essential && \
    rm -rf /var/lib/apt/lists/*

# Install PNPM version matching your local version
RUN npm install -g pnpm@10.8.1

# Copy lockfiles first to leverage Docker cache
COPY package.json pnpm-lock.yaml ./

# Install dependencies with frozen lockfile for deterministic builds
RUN pnpm install --frozen-lockfile

# Copy rest of the source code
COPY . .

# Rebuild native modules (like bcrypt)
RUN pnpm rebuild bcrypt

# Build the app (NestJS build)
RUN pnpm run build

# Run the compiled app
CMD ["node", "dist/main.js"]
