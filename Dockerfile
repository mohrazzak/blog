FROM node:18-alpine

WORKDIR /usr/blog

RUN apk add --update --no-cache openssl

COPY package.json ./
COPY pnpm-lock.yaml ./



RUN npm install pnpm -g; \
    pnpm install

COPY . ./


CMD ["npm","run","start"]
