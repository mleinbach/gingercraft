FROM ubuntu:18.04

RUN apt-get update && apt-get install -y openjdk-8-jre

WORKDIR /opt/minecraft
COPY server.jar /opt/minecraft/server.jar
COPY start_server.sh /opt/minecraft/start_server.sh
RUN java -jar /opt/minecraft/server.jar --nogui \
    && sed -i 's/eula=false/eula=true/' eula.txt

CMD [  "/bin/bash", "start_server.sh" ]