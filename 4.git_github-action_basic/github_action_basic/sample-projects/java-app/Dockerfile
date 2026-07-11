# Stage 1: Build the JAR with Maven
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run the JAR with a lightweight JRE image
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app
COPY --from=builder /app/target/java-basic-app-1.0.0.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
