FROM node:boron

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update \
&& apt-get install -y \
vim

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install
RUN npm install mongodb
RUN npm install body-parser
RUN npm install express


# Bundle app source
COPY . /usr/src/app

EXPOSE 9090 3000
CMD [ "npm", "start" ]
