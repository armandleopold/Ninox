FROM ubuntu:latest
MAINTAINER toto <toto@toto.to>
WORKDIR .
EXPOSE 80
RUN apt-get update
RUN apt-get install -y wget nginx
CMD [ "service", "nginx", "start" ]
