FROM bash:4.4

RUN apk add curl nodejs npm expect && npm install --global yarn

COPY --from=shellspec/shellspec-scratch /opt/shellspec /opt/shellspec

ENV PATH /opt/shellspec/:$PATH

COPY --from=ko1nksm/kcov-alpine /usr/lib/libopcodes-2.34.so /usr/lib/libopcodes-2.34.so
COPY --from=ko1nksm/kcov-alpine /usr/lib/libbfd-2.34.so /usr/lib/libbfd-2.34.so
COPY --from=ko1nksm/kcov-alpine /usr/lib/libdw.so.1 /usr/lib/libdw.so.1
COPY --from=ko1nksm/kcov-alpine /usr/lib/libelf.so.1 /usr/lib/libelf.so.1
COPY --from=ko1nksm/kcov-alpine /usr/lib/libfts.so.0 /usr/lib/libfts.so.0
COPY --from=ko1nksm/kcov-alpine /usr/lib/liblzma.so.5 /usr/lib/liblzma.so.5
COPY --from=ko1nksm/kcov-alpine /usr/lib/libbz2.so.1 /usr/lib/libbz2.so.1
COPY --from=ko1nksm/kcov-alpine /usr/local/bin /usr/local/bin
