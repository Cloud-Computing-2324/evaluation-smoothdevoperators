# Use the official Nginx image as the base image
FROM nginx:1.24.0

# Permissions
RUN chown -R nginx:nginx /usr/share/nginx/html

# Copy the local index.html file to the Nginx document root
COPY index.html /usr/share/nginx/html/index.html
COPY documentation.html /usr/share/nginx/html/documentation.html
COPY report.html /usr/share/nginx/html/report.html
COPY todo.html /usr/share/nginx/html/todo.html
COPY smooth.jpg /usr/share/nginx/html/smooth.jpg