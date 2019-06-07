FROM rocker/verse:latest
MAINTAINER Markus Gesmann markus.gesmann@gmail.com

RUN apt-get update \
	&& apt-get install -y --no-install-recommends apt-utils ed libnlopt-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/


RUN mkdir -p $HOME/.R/ \
    && echo "CXXFLAGS=-O3 -mtune=native -march=native -Wno-unused-variable -Wno-unused-function -flto -ffat-lto-objects  -Wno-unused-local-typedefs -fPIC\n" >> $HOME/.R/Makevars

# Config for rstudio user
RUN mkdir -p $HOME/.R/ \
    && echo "CXXFLAGS=-O3 -mtune=native -march=native -Wno-unused-variable -Wno-unused-function -flto -ffat-lto-objects  -Wno-unused-local-typedefs -Wno-ignored-attributes -Wno-deprecated-declarations -fPIC\n" >> $HOME/.R/Makevars \
    && echo "rstan::rstan_options(auto_write = TRUE)\n" >> /home/rstudio/.Rprofile \
    && echo "options(mc.cores = parallel::detectCores())\n" >> /home/rstudio/.Rprofile

RUN mkdir -p /installation/ && \
    wget https://github.com/jgm/pandoc/releases/download/2.7.2/pandoc-2.7.2-1-amd64.deb \
    --no-check-certificate \
    -O /installation/pandoc.deb

RUN dpkg -i /installation/pandoc.deb && rm -rf /installation/

RUN Rscript -e 'install.packages(c("brms", "bayesplot", "ChainLadder", "raw", \
    "deSolve", "cowplot", "rstan", "tidyverse", "latticeExtra", \
    "rstantools", "data.table", "nlme", "lme4", \
    "modelr", "tidybayes", "loo", "bayesplot", "ggmcmc", "doMC", "glmnet", \
    "mcglm", "bookdown"), dependencies = TRUE,  repos = "https://cloud.r-project.org")'

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
