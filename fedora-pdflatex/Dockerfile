FROM       fedora:22
MAINTAINER dusty@dustymabe.com

# Perform updates
RUN dnf -y update && dnf clean all

# Install basics for latex (includes pdflatex)
RUN dnf install -y texlive-scheme-basic texlive-collection-fontsrecommended && dnf clean all

# Set pdftk as our entrypoint
ENTRYPOINT ["/usr/bin/pdflatex"]
CMD ["--help"]
