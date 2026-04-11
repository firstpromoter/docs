ARG NODE_VERSION=20

FROM node:${NODE_VERSION}-alpine

WORKDIR /app

RUN apk add --no-cache libc6-compat git

COPY . .

CMD ["npx", "mintlify", "dev", "--no-open"]
