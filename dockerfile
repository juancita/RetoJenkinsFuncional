# Utiliza una imagen base de Docker
FROM docker:20.10-dind

# Establece el usuario root
USER root

# Cambia los permisos del socket de Docker
RUN chgrp docker /var/run/docker.sock && \
    chmod 660 /var/run/docker.sock

# Cambia el usuario de nuevo a uno no privilegiado
USER jenkins

# Continúa con el resto del Dockerfile
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
