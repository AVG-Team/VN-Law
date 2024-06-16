# Sử dụng hình ảnh node làm cơ sở
FROM node:14 AS build

# Đặt thư mục làm việc trong container
WORKDIR /app

# Sao chép package.json và package-lock.json vào thư mục làm việc
COPY package*.json ./

# Cài đặt các phụ thuộc
RUN npm install

# Sao chép toàn bộ mã nguồn vào thư mục làm việc
COPY . /app

# Sao chép file .env vào thư mục làm việc
COPY .env ./

# Xây dựng ứng dụng React
RUN npm run build

# Sử dụng một hình ảnh nhỏ hơn để phục vụ ứng dụng
FROM nginx:alpine

# Sao chép cấu hình Nginx vào container
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose cổng 3000 để truy cập ứng dụng
EXPOSE 3000

# Chạy Nginx
CMD ["nginx", "-g", "daemon off;"]
