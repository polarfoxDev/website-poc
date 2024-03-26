FROM node:20-alpine

WORKDIR /app
COPY package.json .
COPY package-lock.json .
RUN npm ci
COPY . .
RUN npm run build --configuration=production

FROM nginx:alpine
COPY --from=0 /app/dist/website-poc/browser/ /usr/share/nginx/html
COPY /nginx.conf /etc/nginx/conf.d/default.conf

RUN chgrp -R root /var/cache/nginx /var/run /var/log/nginx && \
    chmod -R 770 /var/cache/nginx /var/run /var/log/nginx

EXPOSE 8080
