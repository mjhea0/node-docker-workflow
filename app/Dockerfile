FROM node:latest

RUN mkdir /src

RUN npm install nodemon -g

WORKDIR /src
ADD . /src
RUN npm install

EXPOSE 3000

CMD npm start