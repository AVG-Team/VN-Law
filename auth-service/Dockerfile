# Stage 1: Build ứng dụng
FROM openjdk:21-jdk AS builder
WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN chmod +x mvnw && sed -i 's/\r$//' mvnw
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Stage 2: Runtime
FROM openjdk:21-jre
WORKDIR /app
COPY --from=builder /app/target/auth-service-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 9001
CMD ["java", "-Xms256m", "-Xmx512m", "-jar", "app.jar"]