FROM node:18-slim

# Set working directory
WORKDIR /usr/blog

# Install required build tools for bcrypt and other native modules
RUN apt-get update && \
    apt-get install -y python3 build-essential && \
    rm -rf /var/lib/apt/lists/*

# Copy only the package files first for better Docker caching
COPY package.json pnpm-lock.yaml ./

# Install PNPM globally and app dependencies
RUN npm install -g pnpm && pnpm install --frozen-lockfile

# Copy the rest of your source code
COPY . .

# Rebuild native modules inside the Docker container (important for bcrypt)
RUN pnpm rebuild bcrypt

# Build the NestJS app (transpile TypeScript)
RUN pnpm run build

# Use node to run the compiled app
CMD ["node", "dist/main.js"]
