FROM bash:3.2

RUN apk add curl nodejs npm expect gnupg coreutils perl-utils && npm install --global yarn

WORKDIR /opt/codecov

RUN curl https://keybase.io/codecovsecurity/pgp_keys.asc | gpg --import && \
  curl -Os https://uploader.codecov.io/latest/alpine/codecov && \
  curl -Os https://uploader.codecov.io/latest/alpine/codecov.SHA256SUM && \
  curl -Os https://uploader.codecov.io/latest/alpine/codecov.SHA256SUM.sig && \
  gpg --verify codecov.SHA256SUM.sig codecov.SHA256SUM && \
  shasum -a 256 -c codecov.SHA256SUM && \
  chmod +x codecov

COPY --from=shellspec/shellspec-scratch /opt/shellspec /opt/shellspec

ENV PATH /opt/codecov:/opt/shellspec/:$PATH

COPY --from=ko1nksm/kcov-alpine /usr/lib/libopcodes-2.34.so /usr/lib/libopcodes-2.34.so
COPY --from=ko1nksm/kcov-alpine /usr/lib/libbfd-2.34.so /usr/lib/libbfd-2.34.so
COPY --from=ko1nksm/kcov-alpine /usr/lib/libdw.so.1 /usr/lib/libdw.so.1
COPY --from=ko1nksm/kcov-alpine /usr/lib/libelf.so.1 /usr/lib/libelf.so.1
COPY --from=ko1nksm/kcov-alpine /usr/lib/libfts.so.0 /usr/lib/libfts.so.0
COPY --from=ko1nksm/kcov-alpine /usr/lib/liblzma.so.5 /usr/lib/liblzma.so.5
COPY --from=ko1nksm/kcov-alpine /usr/lib/libbz2.so.1 /usr/lib/libbz2.so.1
COPY --from=ko1nksm/kcov-alpine /usr/local/bin /usr/local/bin
