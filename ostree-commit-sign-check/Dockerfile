FROM registry.fedoraproject.org/fedora:28

# Install rpm-ostree ostree
RUN dnf -y install rpm-ostree ostree && dnf clean all

ADD ./run.sh ./runall.sh /
