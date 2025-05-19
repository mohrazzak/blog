FROM node:18-slim

WORKDIR /usr/blog

# Install dependencies like OpenSSL if needed
RUN apt-get update && \
    apt-get install -y openssl && \
    rm -rf /var/lib/apt/lists/*

# Install PNPM & dependencies
COPY package.json ./
COPY pnpm-lock.yaml ./

RUN npm install -g pnpm && pnpm install

# Copy the rest of the source code
COPY . .

# Start the app
CMD ["npm", "run", "start"]
