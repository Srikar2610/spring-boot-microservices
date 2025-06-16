# ---- Stage 1: Build ----
FROM gradle:8.8-jdk17 AS build
WORKDIR /spring-boot-microservices

# Copy gradle config files
COPY settings.gradle build.gradle gradlew /spring-boot-microservices/
COPY gradle /spring-boot-microservices/gradle/

# Copy rest of the code
COPY . /spring-boot-microservices/

# Build without tests
RUN ./gradlew clean build -x test

# ---- Stage 2: Base runtime ----
FROM openjdk:17-jdk-alpine
WORKDIR /app

# Copy all built JARs
COPY --from=build /spring-boot-microservices/**/build/libs/*.jar /app/

# Just expose ports, don't run all services in one container
EXPOSE 8761 8080 8081 8082 8083

CMD ["sh"]
