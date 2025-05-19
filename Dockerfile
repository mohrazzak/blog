# Use Node 18 slim for consistency and small size
FROM node:18-slim

# Set working directory
WORKDIR /usr/blog

# Install system dependencies needed for sharp and other native modules
RUN apt-get update && apt-get install -y \
    python3 \
    build-essential \
    libcairo2-dev \
    libjpeg-dev \
    libpango1.0-dev \
    libgif-dev \
    librsvg2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install pnpm globally (matching local version)
RUN npm install -g pnpm@10.8.1

# Copy package.json and lockfile first to leverage cache
COPY package.json pnpm-lock.yaml ./

# Install dependencies with frozen lockfile for deterministic installs
RUN pnpm install --frozen-lockfile

# Copy all source files
COPY . .

# Rebuild native modules - bcrypt and sharp
RUN pnpm rebuild bcrypt sharp

# Build the NestJS app
RUN pnpm run build

# Use a non-root user for security (optional but recommended)
RUN useradd -m appuser
USER appuser

# Expose port (adjust if your app listens on a different port)
EXPOSE 3000

# Start the app
CMD ["node", "dist/main.js"]
