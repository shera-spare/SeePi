FROM rocker/shiny-verse:latest

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

# RUN /rocker_scripts/install_shiny_server.sh
# https://github.com/rocker-org/rocker-versioned2/blob/master/scripts/install_shiny_server.sh

RUN install2.r --error tidyverse devtools shinydashboard
RUN installGithub.r shera-spare/RasPi

RUN mkdir -p /app
WORKDIR /app
COPY ui.R /app/ui.r
COPY server.R /app/server.R
COPY runApp.R /app/runApp.R

EXPOSE 8080

ENTRYPOINT [ "R" ]
# CMD R -q -e "source('runApp.R')"
# CMD R CMD BATCH runApp.R