FROM bash:5.0

RUN apk add curl nodejs npm expect && npm install --global yarn

