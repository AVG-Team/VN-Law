# Sử dụng hình ảnh nền Eclipse Temurin cho Java 21
FROM eclipse-temurin:21

# Đặt thư mục làm việc bên trong container
WORKDIR /app

# Sao chép file cấu hình Maven và các file cần thiết để tải dependency
COPY .mvn/ .mvn
COPY mvnw pom.xml ./

# Đảm bảo script mvnw có quyền thực thi và xử lý vấn đề dòng kết thúc
RUN chmod +x mvnw && sed -i 's/\r$//' mvnw

# Tải các dependency cần thiết mà không cần biên dịch
RUN ./mvnw dependency:resolve

# Sao chép toàn bộ dự án vào container
COPY src ./src

# Tải lại các dependencies và biên dịch mã nguồn
RUN ./mvnw package -DskipTests

# Expose cổng ứng dụng
EXPOSE 8761

# Đặt entry point để chạy ứng dụng Spring Boot trực tiếp từ mã nguồn
CMD ["./mvnw", "spring-boot:run"]