FROM ubuntu:16.04

MAINTAINER "Markus Gesmann" markus.gesmann@gmail.com

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:ubuntugis/ubuntugis-unstable

RUN add-apt-repository -y "ppa:marutter/rrutter3.5"
RUN add-apt-repository -y "ppa:marutter/c2d4u3.5"

RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial-cran35/  " >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

RUN apt-get update
RUN apt-get upgrade -y

RUN export DEBIAN_FRONTEND=noninteractive; apt-get -y update \
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
	r-cran-rstan \
	r-cran-latticeextra \
	r-cran-assertthat \
	r-cran-cairo \
	r-cran-codetools \
	r-cran-curl \
	r-cran-data.table \
	r-cran-dplyr \
	r-cran-future \
	r-cran-ggplot2 \
	r-cran-knitr \
	r-cran-lme4  \
	r-cran-nlme \
	r-cran-rcpp \
	r-cran-rcppeigen \
	r-cran-testthat \
	r-cran-tidyr
	
RUN apt-get install -y texinfo \
       texlive-base \
       texlive-extra-utils \
       texlive-fonts-extra \
       texlive-fonts-recommended \
       texlive-generic-recommended \
       texlive-latex-base \
       texlive-latex-extra \
       texlive-latex-recommended \
       texlive-xetex

RUN apt-get install -y pandoc pandoc-citeproc

RUN apt-get install -y libv8-3.14-dev libprotobuf-dev protobuf-compiler libcairo2-dev
RUN add-apt-repository -y ppa:opencpu/jq
RUN apt-get update
RUN apt-get install -y libjq-dev

RUN mkdir -p /installation/ && \
    wget https://github.com/jgm/pandoc/releases/download/2.1.1/pandoc-2.1.1-1-amd64.deb \
    --no-check-certificate \
    -O /installation/pandoc.deb

RUN dpkg -i /installation/pandoc.deb && rm -rf /installation/

RUN Rscript -e 'install.packages(c("brms", "bayesplot", "ChainLadder", "raw", \
    "deSolve", "cowplot", \
    "modelr", "tidybayes", "loo", "bayesplot", "ggmcmc", "doMC", "glmnet", \
    "mcglm", "bookdown"), dependencies = TRUE,  repos = "https://cloud.r-project.org")'

CMD ["/bin/bash"]
