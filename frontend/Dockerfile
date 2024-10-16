#build
FROM node:16 as builder
WORKDIR /usr/src/app
COPY . .
RUN npm install \
    && npm run build

#release
FROM nginx:latest
COPY --from=builder /usr/src/app/dist/frontend /usr/share/nginx/html
COPY --from=builder /usr/src/app/nginx.tmpl /app/nginx.tmpl
EXPOSE 8080