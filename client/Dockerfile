FROM node:14-alpine

WORKDIR /usr/src/app

COPY rollup.config.js ./
COPY package*.json ./

RUN yarn install

COPY ./src ./src
COPY ./public ./public

EXPOSE 5000

ENV HOST=0.0.0.0

CMD [ "yarn", "run", "dev" ]
