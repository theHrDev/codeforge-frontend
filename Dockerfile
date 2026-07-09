FROM node:20-alpine AS build

WORKDIR /app

COPY . .

RUN npm install

RUN npm run build

FROM httpd:2.4

RUN sed -i "s/#LoadModule proxy_module/LoadModule proxy_module/" /usr/local/apache2/conf/httpd.conf

RUN sed -i "s/#LoadModule proxy_http_module/LoadModule proxy_http_module/" /usr/local/apache2/conf/httpd.conf

COPY proxy.conf /usr/local/apache2/conf/extra/proxy.conf

RUN echo "Include /usr/local/apache2/conf/extra/proxy.conf" >> /usr/local/apache2/conf/httpd.conf

COPY --from=build /app/dist/ /usr/local/apache2/htdocs/

EXPOSE 80

CMD ["httpd-foreground"]
