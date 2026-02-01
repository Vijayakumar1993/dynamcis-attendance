FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY /build/libs/Attendance-0.0.1-SNAPSHOT.jar /app/init.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","init.jar"]