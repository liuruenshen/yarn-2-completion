FROM bash:5.0

RUN apk add curl nodejs npm && npm install --global yarn

