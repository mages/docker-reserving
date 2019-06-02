# Docker file with rstan and brms
FROM rocker/tidyverse:latest
MAINTAINER Markus Gesmann  <markus.gesmann@gmail.com>

# Install some dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        autoconf \
        automake \
        cmake \
        libtool \
        pkg-config \
        sudo \
        bzip2 \
        ca-certificates \
        curl \
        gfortran \
        git \
        locales \
        unzip \
        wget \
        zip \
        ssh \
        bzip2 \
        ca-certificates \
        curl \
        groff \
        fuse \
        mime-support \
        libcurl4-gnutls-dev \
        libudunits2-dev \
        libfuse-dev \
        libssl-dev \
        libgl1-mesa-glx \
        libxml2-dev \
        apt-utils \
        ed \
        libnlopt-dev \
        ccache \
        libglu1-mesa-dev \
        python3 \
        libopenblas-dev \
        cargo \
        gdal-bin \
        proj-bin \
        libgdal-dev \
        libproj-dev 

ENV PATH=$PATH:/opt/TinyTeX/bin/x86_64-linux/

## Add LaTeX, rticles and bookdown support
RUN wget "https://travis-bin.yihui.name/texlive-local.deb" \
  && dpkg -i texlive-local.deb \
  && rm texlive-local.deb \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ## for rJava
    default-jdk \
    ## Nice Google fonts
    fonts-roboto \
    ## used by some base R plots
    ghostscript \
    ## used to build rJava and other packages
    libbz2-dev \
    libicu-dev \
    liblzma-dev \
    ## system dependency of hunspell (devtools)
    libhunspell-dev \
    ## system dependency of hadley/pkgdown
    libmagick++-dev \
    ## rdf, for redland / linked data
    librdf0-dev \
    ## for V8-based javascript wrappers
    libv8-dev \
    ## R CMD Check wants qpdf to check pdf sizes, or throws a Warning
    qpdf \
    ## For building PDF manuals
    texinfo \
    ## for git via ssh key
    ssh \
 ## just because
    less \
    vim \
 ## parallelization
    libzmq3-dev \
    libopenmpi-dev \
 && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  ## Use tinytex for LaTeX installation
  && install2.r --error tinytex \
 ## Admin-based install of TinyTeX:
  && wget -qO- \
    "https://github.com/yihui/tinytex/raw/master/tools/install-unx.sh" | \
    sh -s - --admin --no-path \
  && mv ~/.TinyTeX /opt/TinyTeX \
  && /opt/TinyTeX/bin/*/tlmgr path add \
  && tlmgr install metafont mfware inconsolata tex ae parskip listings \
  && tlmgr path add \
  && Rscript -e "tinytex::r_texmf()" \
  && chown -R root:staff /opt/TinyTeX \
  && chown -R root:staff /usr/local/lib/R/site-library \
  && chmod -R g+w /opt/TinyTeX \
  && chmod -R g+wx /opt/TinyTeX/bin \
  && echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron \
  ## Currently (2017-06-06) need devel PKI for ssl issue: https://github.com/s-u/PKI/issues/19
  && install2.r --error PKI \
  ## And some nice R packages for publishing-related stuff
  && install2.r --error --deps TRUE \
    bookdown rticles rmdshower rJava \
  && apt-get clean && \
  rm -rf /var/lib/apt/lists/

# Default to python 3.6
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.5 2 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1

# Install pip
RUN curl -SsL -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm -f get-pip.py

RUN pip3 --no-cache-dir install s3cmd awscli boto3


# Set compiler flag
RUN mkdir $HOME/.R
RUN echo "CXX14FLAGS=-O3 -march=native -mtune=native" >> $HOME/.R/Makevars
RUN echo "CXX14FLAGS += -fPIC" >> $HOME/.R/Makevars


# Update R packages
RUN Rscript -e "update.packages(lib.loc='/usr/local/lib/R/site-library', repos='https://cloud.r-project.org', ask=FALSE)"
# Install additional R packages

ENV CCACHE_BASEDIR /tmp/

# Install packages
RUN install2.r --error --deps TRUE \
    pryr \
    rstan \
    loo \
    bayesplot \
    rstanarm \
    rstantools \
    shinystan \
    ggmcmc \
    brms \
    boot \
    doMC \
    glmnet \
    mcglm \
    mice \
    AID \
    data.table \
    fasttime \
    anytime \
    purrr \
    DMwR \
    caret \
    pROC  \
    PRROC \
    bsts \
    CausalImpact \
    survival \
    flexsurv \
    survAUC \
    statmod \
    tweedie \
    cplm \
    tictoc \
    ChainLadder \
    raw \
    nlme \ 
    lme4 \
    deSolve \
    latticeExtra \
    cowplot \
    modelr \
    tidybayes \
    tinytex \
    && \
    rm -rf /tmp/downloaded_packages/ /tmp/*.rds

