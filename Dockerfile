#My first Dockerfile
FROM jrnold/rstan
MAINTAINER Markus Gesmann  <markus.gesmann@gmail.com>
RUN apt-get update && apt-get dist-upgrade -y
RUN install2.r --error --deps TRUE brms bayesplot ChainLadder \
    data.table nlme lme4 deSolve latticeExtra \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds  
RUN Rscript -e "update.packages(lib.loc='/usr/local/lib/R/site-library', repos='https://cloud.r-project.org', ask=FALSE)"
