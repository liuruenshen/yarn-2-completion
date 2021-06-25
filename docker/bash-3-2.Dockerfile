FROM bash:3.2

RUN apk add curl nodejs npm expect && npm install --global yarn

