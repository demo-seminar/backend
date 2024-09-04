# Step 1: Use an official JDK 22 runtime as a parent image for building
FROM eclipse-temurin:22-jdk-alpine AS build

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy all files from the host to the container's working directory
COPY . .

# Step 4: Build the application using Gradle
RUN ./gradlew bootJar --no-daemon

# Step 5: Use a minimal runtime image for running the application (JDK 22 JRE)
FROM eclipse-temurin:22-jre-alpine

# Step 6: Set the working directory inside the container for runtime
WORKDIR /app

# Step 7: Remove any existing JAR files before copying the new one
RUN rm -f /app/*.jar

# Step 8: Copy the built JAR file from the build stage to the runtime stage
COPY --from=build /app/build/libs/*.jar /app/app.jar

# Step 9: Expose the port the application will run on
EXPOSE 8080

# Step 10: Set the entry point to run the JAR file
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
