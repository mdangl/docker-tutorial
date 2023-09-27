FROM openjdk:17-jdk-alpine
COPY todo-api-1.0.0-SNAPSHOT.jar todo-api-1.0.0-SNAPSHOT.jar
COPY data.mv.db local-db/data.mv.db
CMD ["java","-jar", "/todo-api-1.0.0-SNAPSHOT.jar", "--spring.profiles.active=cli"]