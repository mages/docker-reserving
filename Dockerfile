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
    bookdown rticles rmdshower rJava


RUN mkdir -p /installation/ && \
    wget https://github.com/jgm/pandoc/releases/download/2.7.2/pandoc-2.7.2-1-amd64.deb \
    --no-check-certificate \
    -O /installation/pandoc.deb

RUN dpkg -i /installation/pandoc.deb && rm -rf /installation/

RUN apt-get install -y pandoc-citeproc
