FROM rocker/r-apt:bionic

MAINTAINER "Markus Gesmann" markus.gesmann@gmail.com

RUN apt-get update
RUN apt-get -y build-dep libcurl4-gnutls-dev
RUN apt-get -y install libcurl4-gnutls-dev libmagick++-dev

RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update  \
 && dpkg --configure -a \
 && apt-get -f install -y \
  cargo\
  rustc \
  libcurl4-gnutls-dev \
  libxml2-dev \
  libgit2-dev \
  libcairo2-dev \
  libgtk2.0-dev \
  xvfb \
  xauth \
  xfonts-base \
  libxt-dev \
  qpdf \
  pandoc \
  make \
  wget \
  libmagick++-dev \
  git \
  jags \
  libgdal-dev \
  libgeos-dev \
  libgdal20 \
  libgeos-c1v5 \
  libproj-dev \
  liblwgeom-dev \
  libudunits2-dev \
  postgis \
  libssl-dev \
  libssh2-1-dev

## Update and install rstan
RUN apt-get update && apt-get install -y --no-install-recommends \
  r-cran-matrix \
  r-cran-rstudioapi \
  r-cran-stanheaders \
  r-cran-rstantools \
  r-cran-rstan \
  r-cran-loo \
  r-cran-lme4 \
  r-cran-nlme \
  r-cran-codetools \
  r-cran-rcpp \
  r-cran-data.table \
  r-cran-latticeextra \
  r-cran-tidyverse \
  r-cran-bayesplot \
  r-cran-glmnet \
  r-cran-tinytex \
  r-cran-bayesplot \
  r-cran-knitr \
  r-cran-rmarkdown \
  r-cran-rjags \
  r-cran-igraph \
  r-cran-car \
  r-cran-inline \
  r-cran-kernsmooth \
  r-cran-mvtnorm \
  r-cran-shiny \
  r-cran-htmlwidgets \
  r-cran-jsonlite \
  r-cran-rcppeigen \
  r-cran-bh \
  r-cran-zoo
	
RUN Rscript -e 'install.packages(c("brms", "ChainLadder", "raw", \
    "deSolve", "cowplot", "formatR", "citr", "RefManageR", "bibtex",\
    "modelr", "tidybayes", "loo", "ggmcmc", "doMC", \
    "mcglm", "bookdown"), dependencies = TRUE,  repos = "https://cloud.r-project.org")'

RUN  wget -qO- "https://yihui.name/gh/tinytex/tools/install-unx.sh" | sh

RUN mkdir -p /installation/ && \
    wget https://github.com/jgm/pandoc/releases/download/2.7.2/pandoc-2.7.2-1-amd64.deb \
    --no-check-certificate \
    -O /installation/pandoc.deb

RUN dpkg -i /installation/pandoc.deb && rm -rf /installation/

RUN apt-get install -y pandoc-citeproc
