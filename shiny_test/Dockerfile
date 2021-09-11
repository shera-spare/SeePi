FROM r-base:latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    make \
    liblapack-dev \
    libpq-dev \
    libsodium-dev \
    libicu-dev \
    libssl-dev\
    libcurl4-gnutls-dev

ENTRYPOINT [ "R" ]