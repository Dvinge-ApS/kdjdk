FROM nginx:alpine

# Copy the content of the current directory to the nginx html directory
COPY . /usr/share/nginx/html/

# Copy the custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# For debugging: List the contents of the html directory
RUN ls -la /usr/share/nginx/html/