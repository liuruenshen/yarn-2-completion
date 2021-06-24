FROM bash:4.4

RUN apk add curl nodejs npm expect && npm install --global yarn

