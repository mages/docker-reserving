FROM ubuntu:16.04

MAINTAINER "Markus Gesmann" markus.gesmann@gmail.com

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:ubuntugis/ubuntugis-unstable

RUN add-apt-repository -y "ppa:marutter/rrutter"
RUN add-apt-repository -y "ppa:marutter/c2d4u"

RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

RUN echo "deb http://ppa.launchpad.net/jonathonf/texlive-2018/ubuntu xenial main" >> /etc/apt/sources.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys  F06FC659

RUN apt-get update
RUN apt-get upgrade -y

RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update  \
 && apt-get install -y \
	libcurl4-openssl-dev \
	qpdf \
	pandoc \
	make \
	wget \
	git \
	libgdal-dev \
	libgeos-dev \
	libproj-dev \
	liblwgeom-dev \
	libudunits2-dev \
	postgis \
	r-base-dev \
	r-cran-rstan

RUN add-apt-repository ppa:jonathonf/texlive-2018

RUN apt-get install -y texinfo \
       texlive-base \
       texlive-extra-utils \
       texlive-fonts-extra \
       texlive-fonts-recommended \
       texlive-generic-recommended \
       texlive-latex-base \
       texlive-latex-extra \
       texlive-latex-recommended

RUN apt-get install -y  pandoc pandoc-citeproc

RUN apt-get install -y  libv8-3.14-dev libprotobuf-dev protobuf-compiler libcairo2-dev
RUN add-apt-repository -y ppa:opencpu/jq
RUN apt-get update
RUN apt-get install -y libjq-dev

RUN mkdir -p /installation/ && \
    wget https://github.com/jgm/pandoc/releases/download/2.7.2/pandoc-2.7.2-1-amd64.deb \
    --no-check-certificate \
    -O /installation/pandoc.deb

RUN dpkg -i /installation/pandoc.deb && rm -rf /installation/

RUN Rscript -e 'install.packages(c("brms", "bayesplot", "ChainLadder", "raw", \
    "data.table", "nlme", "lme4", "deSolve", "latticeExtra", "cowplot", \
    "modelr", "tidybayes", "loo", "bayesplot", "ggmcmc", "doMC", "glmnet", \
    "mcglm", "bookdown"), dependencies = TRUE,  repos = "https://cloud.r-project.org")'
