FROM openjdk:21-ea-11-jdk-slim

COPY ./target/api-gateway-0.0.1-SNAPSHOT.jar /usr/src/api-gateway/api-gateway.jar

WORKDIR /usr/src/api-gateway

EXPOSE 9000

CMD ["java", "-jar", "api-gateway.jar"]