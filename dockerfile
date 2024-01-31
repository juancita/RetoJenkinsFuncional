FROM ubuntu:20.04

# Instala las herramientas necesarias
RUN apt-get update && \
    apt-get install -y curl \
                       gnupg \
                       lsb-release

# Instala Docker CLI
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh

# Copia un script que configurará los permisos del socket de Docker
COPY set_docker_socket_permissions.sh /usr/local/bin/set_docker_socket_permissions.sh

# Otorga permisos de ejecución al script
RUN chmod +x /usr/local/bin/set_docker_socket_permissions.sh

# Ejecuta el script para configurar los permisos del socket de Docker
RUN set_docker_socket_permissions.sh


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
