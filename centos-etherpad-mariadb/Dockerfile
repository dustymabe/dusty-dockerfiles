FROM       centos:7
MAINTAINER Dusty Mabe <dusty@dustymabe.com>

# Update everything
RUN yum -y update && yum clean all

# Install epel-release & then the rest
RUN yum -y install epel-release     && \
    yum -y install openssl npm node && \
    yum clean all

RUN mkdir /var/lib/etherpad
WORKDIR   /var/lib/etherpad

# Get etherpad 1.5.7
RUN curl -L https://github.com/ether/etherpad-lite/tarball/1.5.7 | tar -xz --strip-components=1

# Add settings.json
COPY settings.json ./
# Add startup script
COPY docker-entrypoint.sh ./

# Listens on 9001 by default
EXPOSE 9001
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["--root"] # Allows to be run as root user
