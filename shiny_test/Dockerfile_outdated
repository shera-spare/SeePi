FROM arm32v7/ubuntu:focal

# Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library

RUN useradd docker \
    && mkdir /home/docker \
    && chown docker:docker /home/docker \
    && addgroup docker staff

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    apt-utils \
    ed \
    less \
    locales \
    vim-tiny \
    wget \
    ca-certificates \
    apt-transport-https \
    gsfonts \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# Configure default locale, see https://github.com/rocker-org/rocker/issues/19
# https://www.thomas-krenn.com/de/wiki/Locales_unter_Ubuntu_konfigurieren
RUN echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen \
&& locale-gen de_DE.utf8 \
&& /usr/sbin/update-locale LANG=de_DE.UTF-8
ENV LC_ALL de_DE.UTF-8
ENV LANG de_DE.UTF-8

# RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/" > /etc/apt/ sources.list.d/cran.list

# note the proxy for gpg

# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9

# RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/'

# Now install R and littler, and create a link for littler in /usr/local/bin

# Also set a default CRAN repo, and make sure littler knows about it too

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    make \
    liblapack-dev \
    libpq-dev \
    libsodium-dev \
    libicu-dev \
    libssl-dev\
    libcurl4-gnutls-dev\
    r-base-core\
    r-base \
    r-base-dev \
    r-recommended \
    littler \
    r-cran-littler \
    && echo 'options(repos = c(CRAN = "https://cloud.r-project.org/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site \
    && echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r \
    && ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r \
    && ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r \
    && ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
    && ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
    && install.r docopt \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "R" ]