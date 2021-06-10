FROM bash:3.2

RUN apk add curl nodejs npm && npm install --global yarn

