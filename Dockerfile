FROM amazoncorretto:17-alpine3.17-jdk

RUN apk update
RUN apk upgrade

RUN apk add git
RUN git clone https://github.com/ogi-iii/kafka-streams-pipeline.git

WORKDIR /kafka-streams-pipeline/

RUN sed -i -e "s/localhost$/host.docker.internal/g" ./app/src/main/resources/app.properties
RUN sed -i -e "s/localhost:8081/host.docker.internal:8081/g" ./app/src/main/resources/app.properties

RUN ./gradlew assemble

ENTRYPOINT java -jar ./app/build/libs/kafka-streams-pipeline-1.0.0-SNAPSHOT-all.jar
