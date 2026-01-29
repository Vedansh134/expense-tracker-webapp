# ---------------------------------------------------
# ============= Stage - 1 : Builder Stage ===========
# ---------------------------------------------------

# Base Image - Maven
FROM maven:3.8.3-openjdk-17 AS builder

# Set working directory
WORKDIR /app

# Copy source code from local to container
COPY . /app

# Build application and skip test cases
RUN mvn clean install -DskipTests=true

# ---------------------------------------------------
# ============= Stage - 2 : Runtime Stage ===========
# ---------------------------------------------------

# Import small size java image
FROM amazoncorretto:17-alpine

# Set working directory
WORKDIR /app

# Copy from the Builder Stage
COPY --from=builder /app/target/*.jar /app/target/expenseapp.jar

# Expose the application
EXPOSE 8080

# Start the application
ENTRYPOINT ["java","-jar","/app/target/expenseapp.jar"]
