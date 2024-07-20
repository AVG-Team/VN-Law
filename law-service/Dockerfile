# Use an OpenJDK 21 base image
FROM openjdk:21-jdk

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven wrapper and project files
COPY .mvn/ .mvn
COPY mvnw pom.xml ./

# Ensure the Maven wrapper is executable and clean up file formatting
RUN chmod +x mvnw && sed -i 's/\r$//' mvnw

# Download the project dependencies
RUN ./mvnw dependency:resolve

# Copy the entire project source
COPY src ./src

# Set the entry point to run the Spring Boot application
CMD ["./mvnw", "spring-boot:run"]

# Expose the application port
EXPOSE 9002
