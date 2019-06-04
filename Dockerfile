FROM ubuntu:bionic

MAINTAINER "Markus Gesmann" markus.gesmann@gmail.com

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:ubuntugis/ubuntugis-unstable

RUN add-apt-repository -y "ppa:marutter/rrutter"
RUN add-apt-repository -y "ppa:marutter/c2d4u"

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
	r-cran-rstan

RUN apt-get install -y texinfo \
       texlive-base \
       texlive-extra-utils \
       texlive-fonts-extra \
       texlive-fonts-recommended \
       texlive-generic-recommended \
       texlive-latex-base \
       texlive-latex-extra \
       texlive-latex-recommended

RUN apt-get install -y pandoc pandoc-citeproc

RUN apt-get install -y libv8-3.14-dev libprotobuf-dev protobuf-compiler libcairo2-dev
RUN add-apt-repository -y ppa:opencpu/jq
RUN apt-get update
RUN apt-get install -y libjq-dev

RUN apt-get update \
        && apt-get install -y --no-install-recommends \
                 littler \
 		 r-base \
 		 r-base-dev \
 		 r-recommended \
  	&& ln -s /usr/lib/R/site-library/littler/examples/install.r /usr/local/bin/install.r \
 	&& ln -s /usr/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r \
 	&& ln -s /usr/lib/R/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
 	&& ln -s /usr/lib/R/site-library/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
 	&& install.r docopt \
 	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
 	&& rm -rf /var/lib/apt/lists/*

RUN install2.r --error --deps TRUE rstan brms bayesplot ChainLadder raw \
    data.table nlme lme4 deSolve latticeExtra \
    cowplot modelr tidybayes \
    loo bayesplot ggmcmc doMC \
    glmnet mcglm bookdown tinytex 

CMD ["/bin/bash"]
