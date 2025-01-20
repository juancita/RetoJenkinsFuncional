# Etapa 1: Construcción de la aplicación
FROM node:18 as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Etapa 2: Configuración de Nginx para servir la aplicación
FROM nginx:alpine
ADD ./config/nginx.conf /etc/nginx/conf.d/nginx.conf
COPY --from=build /app/dist /var/www/app/
EXPOSE 5174
CMD ["nginx", "-g", "daemon off;"]
