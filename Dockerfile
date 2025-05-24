FROM node:16-alpine

WORKDIR /usr/blog

RUN apk add --update --no-cache openssl1.1-compat

COPY package.json ./



RUN npm install

COPY . ./


CMD ["nest","start"]