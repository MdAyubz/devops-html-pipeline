#FROM nginx:alpine
#COPY index.html /usr/share/nginx/html/index.html

FROM nginx:alpine

# Copy your HTML to the default nginx html folder
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80 to the outside world
EXPOSE 80

# Start nginx (this is optional because nginx image already has it)
CMD ["nginx", "-g", "daemon off;"]

