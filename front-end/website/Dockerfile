# Sử dụng hình ảnh base là node
FROM node:16

# Tạo thư mục để chứa ứng dụng
WORKDIR /app

# Copy các file cần thiết và cài đặt dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy toàn bộ mã nguồn vào container
COPY . .

# Copy file .env vào container
COPY .env /app/.env

# Build ứng dụng
RUN npm run build

# Expose cổng mà ứng dụng sẽ chạy
EXPOSE 5173

# Lệnh để chạy ứng dụng
CMD ["sh", "-c", "npm run preview -- --host 0.0.0.0 --port 5173"]
