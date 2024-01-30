FROM node:18 as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
ADD ./config/nginx.conf /etc/nginx/conf.d/nginx.conf
COPY --from=build /app/dist /var/www/app/
EXPOSE 5174
CMD ["nginx", "-g", "daemon off;"]


#FROM debian:bullseye-slim as additional-setup
#RUN apt-get update && apt-get install -y docker.io
#RUN docker exec -it -u root jenkins /bin/bash && \
#   chgrp docker /var/run/docker.sock && \
#   chmod 660 /var/run/docker.sock
