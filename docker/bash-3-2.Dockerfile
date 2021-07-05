FROM bash:3.2

RUN apk add curl nodejs npm expect && npm install --global yarn

COPY --from=shellspec/shellspec-scratch /opt/shellspec /opt/shellspec

ENV PATH /opt/shellspec/:$PATH