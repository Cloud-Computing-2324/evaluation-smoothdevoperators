# Use the official Nginx image as the base image
FROM nginx:latest

# Copy the local index.html file to the Nginx document root
COPY index.html /usr/share/nginx/html/index.html
