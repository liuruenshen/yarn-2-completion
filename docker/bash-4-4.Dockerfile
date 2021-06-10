FROM bash:4.4

RUN apk add curl nodejs npm && npm install --global yarn

