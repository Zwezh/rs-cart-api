FROM node:14-alpine
## Stage 0
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

## Stage 1
FROM node:14-alpine
RUN apk add --no-cache binutils && \
  strip /usr/local/bin/node
ENV NODE_ENV=production
WORKDIR /app/build/
COPY package*.json ./
RUN npm install
COPY --from=0 /app/dist ./dist/

## Stage 2
FROM node:14-alpine
WORKDIR /app
COPY --from=1 /app/build ./
USER node
ENV PORT=8080
EXPOSE 8080
CMD ["node", "dist/main"]
