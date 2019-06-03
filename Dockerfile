FROM rocker/tidyverse:latest
MAINTAINER Markus Gesmann markus.gesmann@gmail.com

# Install ed, since nloptr needs it to compile
# Install clang and ccache to speed up Stan installation
# Install libxt-dev for Cairo 
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       apt-utils \
       ed \
       libnlopt-dev \
       clang \
       ccache \
       libxt-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/

# Set up environment
# Use correct Stan Makevars: https://github.com/stan-dev/rstan/wiki/Installing-RStan-on-Mac-or-Linux#prerequisite--c-toolchain-and-configuration
RUN mkdir -p $HOME/.R \
    # Add global configuration files
    # Docker chokes on memory issues when compiling with gcc, so use ccache and clang++ instead
    && echo '\n \
        \nCC=/usr/bin/ccache clang \
        \n \
        \n# Use clang++ and ccache \
        \nCXX=/usr/bin/ccache clang++ -Qunused-arguments  \
        \n \
        \n# Optimize building with clang \
        \nCXXFLAGS=-g -O3 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2 -g -pedantic -g0 \
        \n \
        \n# Stan stuff \
        \nCXXFLAGS+=-O3 -mtune=native -march=native -Wno-unused-variable -Wno-unused-function -Wno-macro-redefined \
        \n' >> $HOME/.R/Makevars \
    # Make R use ccache correctly: http://dirk.eddelbuettel.com/blog/2017/11/27/
    && mkdir -p $HOME/.ccache/ \
    && echo "max_size = 5.0G \
        \nsloppiness = include_file_ctime \
        \nhash_dir = false \
        \n" >> $HOME/.ccache/ccache.conf \
    # Add configuration files for RStudio user
    && mkdir -p /home/rstudio/.R/ \
    && echo '\n \
        \n# Stan stuff \
        \nCXXFLAGS=-O3 -mtune=native -march=native -Wno-unused-variable -Wno-unused-function -Wno-macro-redefined \
        \n' >> /home/rstudio/.R/Makevars \
    && echo "rstan::rstan_options(auto_write = TRUE)\n" >> /home/rstudio/.Rprofile \
    && echo "options(mc.cores = parallel::detectCores())\n" >> /home/rstudio/.Rprofile

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

RUN apt-get update \ 
	&& apt-get install -y --no-install-recommends \
                   curl 

RUN apt-get update \ 
 	&& apt-get install -t unstable -y --no-install-recommends \
                   texlive-xetex \
                   texlive-fonts-extra

USER rstudio
