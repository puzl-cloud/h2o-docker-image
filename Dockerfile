# Set your custom docker image
FROM ubuntu:18.04

# Ability to specify the interpreter --build-arg INTERPRETER=python3.8, by default python3.7
ARG H2O_VERSION=3.30.0.1

# Add custom env if required
ENV USER=ubuntu \
  UID=1000 \
  GID=1000 \
  H2O_VERSION=${H2O_VERSION}

# Add the necessary packages for installation at the end of the block
RUN apt-get update \
  && apt-get install -y software-properties-common \
  && add-apt-repository ppa:git-core/ppa -y \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
  build-essential \
  openssh-server \
  git \
  locales \
  rsync \
  curl \
  wget \
  telnet \
  screen \
  nano \
  vim \
  default-jdk \
  unzip

# Creating a user to run a container without root
RUN addgroup --gid "$GID" "$USER" \
  && adduser \
  --disabled-password \
  --gecos "" \
  --ingroup "$USER" \
  --uid "$UID" \
  --shell /bin/bash \
  "$USER" \
  && chown $USER:$USER -R /home/"$USER" /tmp

COPY sshd_config /home/"$USER"/.ssh/sshd_config
COPY config /home/"$USER"/.ssh/config
COPY bash.bashrc /etc/bash.bashrc

# Cleaning temporary files
RUN rm -rf \
  /var/lib/apt/lists/* \
  /var/cache/debconf \
  /tmp/* \
  && apt-get clean

# Recreation of references to the interpreter
RUN wget http://h2o-release.s3.amazonaws.com/h2o/rel-zahradnik/1/h2o-${H2O_VERSION}.zip \
	&& unzip h2o-${H2O_VERSION}.zip

WORKDIR /tmp

USER $UID

CMD ["java", "-jar", "/h2o-${H2O_VERSION}/h2o.jar"]