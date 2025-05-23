# Build stage
FROM node:20 AS build-stage

# set the working directory
WORKDIR /app

# Copy the working directory in the container
COPY package*.json ./

# Install the project dependencies
RUN npm install

# Copy the rest of the project files to the container
COPY . .

# Build the Vue.js application to the production mode to dist folder
RUN npm run build

# Production stage
FROM nginx:stable-alpine AS production-stage

# Copy the build application from the previous stage to the Nginx container
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Copy the custom nginx configuration file
COPY ./nginx/myvue.conf /etc/nginx/conf.d/myvue.conf

# Expose the port 80
EXPOSE 80

# Start Nginx to serve the application
CMD ["nginx", "-g", "daemon off;"]