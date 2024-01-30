FROM node:18 as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

USER root 
FROM nginx:alpine as nginx-build
ADD ./config/nginx.conf /etc/nginx/conf.d/nginx.conf

USER nginx
COPY --from=build /app/dist /var/www/app/
EXPOSE 5174
CMD ["nginx", "-g", "daemon off;"]
