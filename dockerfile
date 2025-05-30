# # Step 1: Build React
# FROM node:18 AS build
# WORKDIR /app
# COPY package*.json ./
# RUN npm install
# COPY . .
# RUN npm run build

# # Step 2: Serve with Nginx
# FROM nginx:alpine
# COPY --from=build /app/build /usr/share/nginx/html
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]
# Stage 1: Build the React application
FROM node:21 AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY src/package.json src/package-lock.json ./

# Install dependencies
RUN npm install

# Copy the source code and .env file
COPY src/src ./src
COPY src/public ./public
COPY src/.env .env

# Build the application
RUN npm run build

# Stage 2: Serve the React application
FROM nginx:alpine

# Copy the build files from the first stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy the custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose ports 80 and 443
EXPOSE 80
EXPOSE 443

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]