FROM rocker/hadleyverse:latest
MAINTAINER Markus Gesmann markus.gesmann@gmail.com

## Mostly pirated from Jon Zelner and jrnold/docker-stan

# Install clang to use as compiler
# clang seems to be more memory efficient with the templates than g++
# with g++ rstan cannot compile on docker hub due to memory issues
RUN apt-get update \ 
	&& apt-get install -y --no-install-recommends \
                   clang-3.6 


RUN ln -s /usr/bin/clang++-3.6 /usr/bin/clang++ \
    && ln -s /usr/bin/clang-3.6 /usr/bin/clang

# Global site-wide config
RUN mkdir -p $HOME/.R/ \
    && echo "\nCXX=clang++ -ftemplate-depth-256\n" >> $HOME/.R/Makevars \
    && echo "CC=clang\n" >> $HOME/.R/Makevars

# Install rstan and other packages
RUN install2.r --error --deps TRUE \
    pryr \
    rstan \
    loo \
    bayesplot \
    StanHeaders \
    BH \
    Rcpp \
    REigen \
    rstantools \
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
    knitr \
    bookdown \
    rmarkdown \
    tinytex 


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
