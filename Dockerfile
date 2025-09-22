FROM maven:3.9.11-amazoncorretto-21 AS build
WORKDIR /home/app

COPY ./pom.xml /home/app/pom.xml
COPY ./src/main/java/com/expertsconseil/config_server/ConfigServerApplication.java	/home/app/src/main/java/com/expertsconseil/config_server/ConfigServerApplication.java

RUN mvn -f /home/app/pom.xml clean package

COPY . /home/app
RUN mvn -f /home/app/pom.xml clean package

FROM openjdk:26-slim
EXPOSE 8001
COPY --from=build /home/app/target/*.jar app.jar
ENTRYPOINT [ "sh", "-c", "java -jar /app.jar" ]

