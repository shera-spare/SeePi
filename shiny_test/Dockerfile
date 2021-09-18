FROM r-base:latest AS builder

ENV V_RStudio=R-4.1.1
ENV V_ShinyServer=v1.5.16.958

# ------------------------------------------------------------------------------
# Dependencies 
# ------------------------------------------------------------------------------
RUN apt update -y
RUN apt install -y gfortran \
    libreadline6-dev \
    libx11-dev \
    libxt-dev \
    libpng-dev \
    libjpeg-dev \
    libcairo2-dev \
    xvfb \
    libbz2-dev \
    libzstd-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    texinfo \
    texlive \
    texlive-fonts-extra \
    screen \
    wget \
    libpcre2-dev \
    git \
    apt-utils \
    sed \
    make \
    cmake \
    g++ \
    default-jdk

WORKDIR /

# ------------------------------------------------------------------------------
# Install R packages
# ------------------------------------------------------------------------------
RUN R -e "install.packages(c('shiny', 'Cairo'), repos='http://cran.rstudio.com/')"
# RUN install2.r --error shiny Cairo 

# ------------------------------------------------------------------------------
# Install python 3
# ------------------------------------------------------------------------------
RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && mkdir -p /usr/bin/python \
  && ln -s /usr/bin/python3 /usr/bin/python 

# ------------------------------------------------------------------------------
# Install shiny-server
# ------------------------------------------------------------------------------
# RUN git clone https://github.com/rstudio/shiny-server.git \
#     && mkdir shiny-server/tmp \
#     && cd / \
#     && git clone https://github.com/tylurp/shiny-server-arm.git \
#     && cp /shiny-server-arm/binding.gyp /shiny-server/tmp/binding.gyp \
#     && cp /shiny-server-arm/determine_arch.sh /shiny-server/determine_arch.sh \
#     && chmod +x /shiny-server/determine_arch.sh && \
#     && /shiny-server/determine_arch.sh
RUN git clone https://github.com/rstudio/shiny-server.git \
    && mkdir shiny-server/tmp \
    && git clone https://github.com/tylurp/shiny-server-arm.git \
    && cp /shiny-server-arm/binding.gyp /shiny-server/tmp/binding.gyp \
    && cp /shiny-server-arm/determine_arch.sh /determine_arch.sh \
    && chmod +x determine_arch.sh \
    && ./determine_arch.sh

WORKDIR /shiny-server/tmp/

#Install node for rshiny. Currently only --unsafe-perm works (see https://github.com/npm/npm/issues/3497) 
# RUN PYTHON=`which python`
RUN mkdir ../build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DPYTHON=python ../ && \
    make -j4 && \
    ../external/node/install-node.sh && \
    ../bin/node ../ext/node/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js configure && \
    ../bin/node ../ext/node/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js --python=python rebuild && \
    ../bin/npm --python=python install --no-optional && \
    ../bin/npm --python=python install --no-optional --unsafe-perm && \
    ../bin/npm --python=python rebuild && \
    make -j4 install

# ------------------------------------------------------------------------------
# Clean up
# ------------------------------------------------------------------------------

FROM r-base:latest
COPY --from=builder /usr/bin/R /usr/local/bin/R
COPY --from=builder /usr/lib/R /usr/local/lib/R
COPY --from=builder /usr/bin/Rscript /usr/local/bin/Rscript
COPY --from=builder /usr/local/shiny-server /usr/local/shiny-server
COPY --from=builder /shiny-server-arm /shiny-server-arm
WORKDIR /

RUN useradd -r -m shiny \
    && ln -s /usr/local/shiny-server/bin/shiny-server /usr/bin/shiny-server \
    && mkdir -p /var/log/shiny-server \
    && mkdir -p /srv/shiny-server \
    && chown shiny /var/log/shiny-server \
    && mkdir -p /var/lib/shiny-server \
    && mkdir -p /etc/shiny-server \
    && cp /shiny-server-arm/shiny-server.conf /etc/shiny-server/shiny-server.conf \
    && cp /shiny-server-arm/init.sh /etc/shiny-server/init.sh \
    && chmod 777 /etc/shiny-server/init.sh \
    && chmod -R 777 /var/log/shiny-server \
    && chmod -R 777 /srv/shiny-server \
    && chmod -R 777 /var/lib/shiny-server \
    && chmod -R 777 /srv/shiny-server \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       gfortran \
       libreadline6-dev \
       libcurl4-openssl-dev \
       libcairo2-dev \
       xvfb \
       libx11-dev \
       libxt-dev \
       libpng-dev \
       libjpeg-dev \
       libbz2-dev \
       libzstd-dev \
       liblzma-dev \
       libatomic1 \
       libgomp1 \
       libpcre2-8-0 \
       libssl-dev \
       libxml2-dev \
       g++ \
       make \
       liblapack-dev \
       libpq-dev \
       libsodium-dev \
       libicu-dev \
       libxml2-dev\
       libgit2-dev\
       build-essential

RUN install2.r --error tidyverse devtools shinydashboard
RUN installGithub.r shera-spare/RasPi

#RUN mkdir -p /app
#WORKDIR /app
#COPY ui.R /app/ui.r
#COPY server.R /app/server.R
#COPY runApp.R /app/runApp.R

#EXPOSE 8080
WORKDIR /

#Create folder structure and set permissions
RUN mkdir -p        /var/log/shiny-server && \
    chown shiny     /var/log/shiny-server && \
    chmod -R 777    /var/log/shiny-server && \
    mkdir -p        /srv/shiny-server     && \
    chmod -R 777    /srv/shiny-server     && \
    mkdir -p        /var/lib/shiny-server && \
    chmod -R 777    /var/lib/shiny-server && \
    mkdir -p        /etc/shiny-server     && \
    chmod -R 777    /srv/shiny-server

#Shiny server configuration
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

#Init file for installing R-packages from host
COPY init.sh /etc/shiny-server/init.sh
RUN chmod 777 /etc/shiny-server/init.sh

# ENTRYPOINT [ "R" ]
# CMD R -q -e "source('runApp.R')"
#CMD R CMD BATCH runApp.R
RUN mkdir /srv/shiny-server/app01
COPY app01/* /srv/shiny-server/app01/ 
RUN chmod -R 777 /src/shiny-server/app01
EXPOSE 3838

ENTRYPOINT ["/etc/shiny-server/init.sh"]
