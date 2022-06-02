# Form Sapian/fffmpeg who is rocky linux from jrottenberg/ffmpeg 
FROM sapian/ffmpeg:4.4.0-rockylinux

# set environment varibles
ENV LOG_LEVEL INFO

# set work directory
WORKDIR /usr/src/app/

# Install Epel
RUN dnf -y install epel-release \
  	&& dnf clean all \
  	&& rm -rf /var/cache/yum

# Install baresip from epel repo

RUN dnf -y install pulseaudio baresip baresip-pulse baresip-opus baresip-mqtt baresip-sndfile \
  	&& dnf clean all \
  	&& rm -rf /var/cache/yum

# Install python3-pip
RUN dnf -y install which git python39-pip \
  	&& dnf clean all \
  	&& rm -rf /var/cache/yum

# install dependencies
RUN ln -s /usr/bin/pip3.9 /usr/bin/pip
RUN pip install --upgrade pip
RUN pip install pipenv
COPY ./Pipfile /usr/src/app/Pipfile
RUN pipenv install --skip-lock --system

# Create User baresip
RUN useradd -rm -d /home/baresip -s /bin/bash -u 1000 baresip

# Copy project
COPY joe /usr/src/app/joe/
COPY *.md /usr/src/app/joe/
COPY entrypoint.sh /usr/src/app/entrypoint.sh
WORKDIR /usr/src/app/joe/
RUN python3 setup.py install

# # Install python3-pip
# # RUN apt-get update \
# #       && apt-get install -y vim \
# #       && rm -rf /var/lib/apt/lists/*

USER baresip

CMD python3 joe/joke.py

# run entrypoint.sh
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="joe-baresip" \
      org.label-schema.description="joe J.A.R.V.I.S Online Edition for baresip" \
      org.label-schema.url="https://www.sapian.cloud/joe-baresip" \
      org.label-schema.vcs-url="https://git.sapian.com.co/Sapian/joe-baresip" \
      org.label-schema.maintainer="sebastian.rojo@sapian.com.co" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vendor1="Sapian" \
      org.label-schema.version=$VERSION
