FROM openjdk:8-jre-alpine
WORKDIR /demo
COPY /target/code-coverage-maven-jacoco.jar /app 
CMD ["java -jar code-coverage-maven-jacoco.jar"] 
