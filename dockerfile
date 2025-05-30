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
# STEP 1: Build React app
FROM node:18 AS build

WORKDIR /app

# ติดตั้ง dependencies
COPY package*.json ./
RUN npm install

# คัดลอก source code + .env
COPY . .

# ✅ React จะอ่าน .env ตรงนี้ตอน build
RUN npm run build

# STEP 2: Serve with nginx
FROM nginx:alpine

# ลบ default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# ✅ คัดลอก build ที่ถูกสร้างจาก step แรก
COPY --from=build /app/build /usr/share/nginx/html

# ✅ เพิ่ม nginx config ถ้ามี (ไม่บังคับ)
# COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
