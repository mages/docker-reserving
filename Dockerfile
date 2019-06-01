# Docker file with rstan and brms
FROM rocker/verse:latest
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
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/

# Default to python 3.6
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.5 2 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1

# Install pip
RUN curl -SsL -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm -f get-pip.py

RUN pip3 --no-cache-dir install s3cmd awscli boto3

# Make ~/.R
RUN mkdir -p $HOME/.R/ \
    && echo "\nCXX14FLAGS += -fPIC\n" >> $HOME/.R/Makevars \
    && echo "CC=clang\n" >> $HOME/.R/Makevars


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

RUN install2.r --error --deps TRUE \
    -r 'https://inla.r-inla-download.org/R/stable' \
    INLA \
    && \
    rm -rf /tmp/downloaded_packages/ /tmp/*.rds


RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
                   curl

RUN apt-get update \
 	&& apt-get install -t unstable -y --no-install-recommends \
                   texlive-xetex \
                   texlive-fonts-extra

