FROM nginx:alpine
COPY ecs-web-app/src/index.html /usr/share/nginx/html/index.html
EXPOSE 80
