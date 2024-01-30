# Utilizar una imagen de Docker como base, que incluya el cliente de Docker
FROM docker:latest as docker

# Instalar las dependencias necesarias para ejecutar Docker dentro del contenedor
RUN apk --no-cache add curl

# Descargar el binario de Docker para DinD
RUN curl -sSL -o /usr/local/bin/dockerd-entrypoint.sh https://raw.githubusercontent.com/docker-library/docker/master/20.10/dind/dockerd-entrypoint.sh

# Dar permisos de ejecución al script de entrada de Docker
RUN chmod +x /usr/local/bin/dockerd-entrypoint.sh

# Etapa de construcción del proyecto de Node.js
FROM node:18 as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Utilizar la imagen de DinD como base
FROM docker as dind

# Ejecutar Docker dentro del contenedor
ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh"]

# Etapa final para copiar los artefactos construidos y configurar Nginx
FROM nginx:alpine
ADD ./config/nginx.conf /etc/nginx/conf.d/nginx.conf
COPY --from=build /app/dist /var/www/app/
EXPOSE 5174
CMD ["nginx", "-g", "daemon off;"]
