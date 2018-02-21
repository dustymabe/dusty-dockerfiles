FROM registry.fedoraproject.org/fedora:latest

# Install pagure/fedmsg libraries
RUN dnf -y install python3-libpagure python3-fedmsg && dnf clean all

ADD failed-compose-checker.py /usr/local/bin/

CMD /usr/local/bin/failed-compose-checker.py 
