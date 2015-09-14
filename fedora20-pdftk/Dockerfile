# pdftk was last packaged for Fedora 20
FROM       fedora:20
MAINTAINER dusty@dustymabe.com

# Perform updates
RUN yum -y update && yum clean all

# Install pdftk
RUN yum install -y pdftk && yum clean all

# Set pdftk as our entrypoint
ENTRYPOINT ["/usr/bin/pdftk"]
CMD ["--help"]
