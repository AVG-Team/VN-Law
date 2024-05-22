# Sử dụng hình ảnh nền Eclipse Temurin cho Java 21
FROM eclipse-temurin:21-jdk AS build

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

# Sử dụng hình ảnh nhỏ gọn để chạy ứng dụng
FROM eclipse-temurin:21-jre

# Đặt thư mục làm việc bên trong container
WORKDIR /app

# Sao chép file JAR từ giai đoạn build
COPY --from=build /app/target/*.jar app.jar

# Expose cổng ứng dụng
EXPOSE 9000

# Đặt entry point để chạy ứng dụng Spring Boot
ENTRYPOINT ["java", "-jar", "app.jar"]
