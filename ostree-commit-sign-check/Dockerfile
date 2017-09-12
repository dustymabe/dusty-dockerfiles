FROM registry.fedoraproject.org/fedora:26

# Install rpm-ostree ostree
RUN dnf -y install rpm-ostree ostree && dnf clean all

ADD ./run.sh /
