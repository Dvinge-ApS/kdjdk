FROM nginx:alpine

# Copy the content of the current directory to the nginx html directory
COPY . /usr/share/nginx/html/

# Copy the custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8081