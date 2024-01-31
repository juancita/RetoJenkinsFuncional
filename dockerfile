FROM ubuntu:20.04

# Copia el socket de Docker al directorio /tmp dentro del contenedor
COPY /var/run/docker.sock /tmp/docker.sock

# Cambia el propietario y el grupo del socket de Docker
RUN chown root:root /tmp/docker.sock && \
    chmod 660 /tmp/docker.sock


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
