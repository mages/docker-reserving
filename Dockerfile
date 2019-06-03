# Docker file with rstan and brms
FROM jrnold/rstan
MAINTAINER Markus Gesmann  <markus.gesmann@gmail.com>
RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install jags
# Set compiler flag
RUN echo "CXX14FLAGS=-O3 -march=native -mtune=native" >> $HOME/.R/Makevars
RUN echo "CXX14FLAGS += -fPIC" >> $HOME/.R/Makevars
# Remove old rstan installation 2.18.1
RUN Rscript -e "remove.packages('rstan')"
# Update R packages
RUN Rscript -e "update.packages(lib.loc='/usr/local/lib/R/site-library', repos='https://cloud.r-project.org', ask=FALSE)"
# Install additional R packages
RUN install2.r --error --deps TRUE rstan brms bayesplot ChainLadder raw \
    data.table nlme lme4 deSolve latticeExtra \
    cowplot modelr tidybayes \
    loo bayesplot ggmcmc doMC \
    glmnet mcglm bookdown tinytex 

RUN echo 'deb http://http.us.debian.org/debian/ testing non-free contrib main' >> /etc/apt/sources.list
RUN apt-get update \ 
	&& apt-get install -y --no-install-recommends \
                   curl 

RUN apt-get update \ 
 	&& apt-get install -t unstable -y --no-install-recommends \
                   texlive-xetex \
                   texlive-fonts-extra
