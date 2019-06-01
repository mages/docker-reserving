FROM rocker/verse:latest
MAINTAINER Markus Gesmann markus.gesmann@gmail.com

## Mostly copied from Jeffrey Arnold and Jon Zelner

# Install clang to use as compiler
# clang seems to be more memory efficient with the templates than g++
# with g++ rstan cannot compile on docker hub due to memory issues

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

RUN apt-get update && apt-get install -y apt-transport-https

RUN apt-get install -y --no-install-recommends clang-3.6

RUN ln -s /usr/bin/clang++-3.6 /usr/bin/clang++ \
    && ln -s /usr/bin/clang-3.6 /usr/bin/clang

 
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
pngquant \
libxml2-dev \
libxt-dev \
libjpeg-dev \
cargo \
libglu1-mesa-dev \
libcairo2-dev \
libsqlite3-dev \
libmariadbd-dev \
libmariadb-client-lgpl-dev \
libpq-dev \
libssh2-1-dev \
# Global site-wide config
RUN mkdir -p $HOME/.R/ \
    && echo "\nCXX=clang++ -ftemplate-depth-256\n" >> $HOME/.R/Makevars \
    && echo "CC=clang\n" >> $HOME/.R/Makevars

# Install rstan
RUN install2.r --error \
    inline \
    RcppEigen \
    StanHeaders \
    rstan \
    KernSmooth \
    knitr \
    tidyverse \
    DT \
    ChainLadder \
    data.table \
    latticeExtra \
    brms \
    tiybayes \
    modelr \
    raw \
    ggplot2 \
    deSolve \
    bayesplot \
    expint \
    inline \   
    devtools \
    rstantools \
    stringr \
    nlme \ 
    lme4 \
    cowplot 

# Config for rstudio user
RUN mkdir -p /home/rstudio/.R/ \
    && echo "\nCXX=clang++ -ftemplate-depth-256\n" >> /home/rstudio/.R/Makevars \
    && echo "CC=clang\n" >> /home/rstudio/.R/Makevars \
    && echo "CXXFLAGS=-O3\n" >> /home/rstudio/.R/Makevars \
    && echo "\nrstan::rstan_options(auto_write = TRUE)" >> /home/rstudio/.Rprofile \
    && echo "options(mc.cores = parallel::detectCores())" >> /home/rstudio/.Rprofile

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
                   curl

RUN apt-get update \
 	&& apt-get install -t unstable -y --no-install-recommends \
                   texlive-xetex \
                   texlive-fonts-extra

USER rstudio
