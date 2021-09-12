FROM r-base:latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    make \
    liblapack-dev \
    libpq-dev \
    libsodium-dev \
    libicu-dev \
    libssl-dev\
    libcurl4-gnutls-dev\
    libxml2-dev\
    libgit2-dev\
    build-essential

RUN install2.r --error tidyverse devtools shiny shinydashboard
RUN installGithub.r shera-spare/RasPi

RUN mkdir -p /app
WORKDIR /app
COPY ui.R /app/ui.r
COPY server.R /app/server.R

EXPOSE 8080

# ENTRYPOINT [ "R" ]
CMD R -q -e "shiny::runApp(port=8080, host='0.0.0.0')"