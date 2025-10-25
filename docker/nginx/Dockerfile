FROM nginx:stable-alpine

# Install necessary packages
RUN apk update && apk add --no-cache bash

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom nginx config
COPY conf.d/app.conf /etc/nginx/conf.d/

# Expose ports
EXPOSE 8080 4433

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
