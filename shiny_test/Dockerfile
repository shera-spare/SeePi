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

RUN install2.r --error tidyverse devtools shiny shinydashboard

RUN R -e "source(devtools::install_github('shera-spare/RasPi'))"
RUN kmdir -p /app
COPY ui.R /app/ui.r
COPY server.R /app/server.R

ENTRYPOINT [ "R" ]