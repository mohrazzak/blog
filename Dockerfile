FROM node:18-slim

WORKDIR /usr/blog

# Install dependencies and build tools required for native modules like bcrypt
RUN apt-get update && \
    apt-get install -y openssl python3 build-essential && \
    rm -rf /var/lib/apt/lists/*

# Install PNPM & dependencies
COPY package.json ./
COPY pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install

# Copy the rest of the source code
COPY . .

# Start the app
CMD ["npm", "run", "start"]
