#Build layer
FROM node:14-alpine
WORKDIR /build
COPY package*.json ./
RUN npm i
COPY . .
RUN npm run build && npm prune --production

#Prod layer
FROM node:14-alpine
WORKDIR ../app
COPY package*.json ./
COPY --from=0 /build/node_modules ./node_modules
COPY --from=0 /build/dist ./dist
USER node
ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/main"]