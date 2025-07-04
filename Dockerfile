FROM node:18-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm config set fetch-retries 5 \
&& npm config set fetch-retry-mintimeout 20000 \
&& npm config set fetch-retry-maxtimeout 120000 \
&& npm ci
COPY . .
RUN npm run build

FROM node:18-alpine
WORKDIR /app
RUN npm install -g serve
COPY --from=build /app/dist /app
ENV PORT=5001
ENV NODE_ENV=production
EXPOSE 5001
CMD ["serve", "-s", ".", "-l", "5001"]

