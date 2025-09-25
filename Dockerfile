FROM maven:3.9.11-amazoncorretto-21 AS build
WORKDIR /home/app

COPY ./pom.xml /home/app/pom.xml
COPY ./src/main/java/com/expertsconseil/config_server/ConfigServerApplication.java	/home/app/src/main/java/com/expertsconseil/config_server/ConfigServerApplication.java

RUN mvn -f /home/app/pom.xml clean package

COPY . /home/app
RUN mvn -f /home/app/pom.xml clean package

FROM openjdk:26-slim

# Installer curl pour le healthcheck
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 8050
COPY --from=build /home/app/target/*.jar app.jar
ENTRYPOINT [ "sh", "-c", "java -jar /app.jar" ]
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8050/actuator/health || exit 1