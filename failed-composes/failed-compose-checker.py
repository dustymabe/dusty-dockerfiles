#!/usr/bin/python3
import fedmsg
import re
import os
from libpagure import Pagure

# Set logging to not print warnings
import logging
log = logging.getLogger('fedmsg')
log.setLevel(logging.ERROR)

# Connect to pagure and set it to point to our repo
PAGURE_REPO='dusty/failed-composes'

########import json
########msg = json.loads("""{
########                "msg": {
########                    "status": "DOOMED",
########                    "release_type": "ga",
########                    "compose_label": null,
########                    "compose_respin": 0,
########                    "compose_date": "20180215",
########                    "release_version": "Bikeshed",
########                    "location": "http://kojipkgs.fedoraproject.org/compose/Fedora-Modular-Bikeshed-20180215.n.0/compose",
########                    "compose_type": "nightly",
########                    "release_is_layered": false,
########                    "release_name": "Fedora-Modular",
########                    "release_short": "Fedora-Modular",
########                    "compose_id": "Fedora-Modular-Bikeshed-20180215.n.0"
########                  }}
########"""
########)



def main():
    # grab token and connec to pagure
    token = os.getenv('PAGURE_TOKEN')
    if token:
        pg = Pagure(pagure_token=token)
    else:
        print("No token was detected.") 
        print("This script will run but won't be able to create new issues.")
        pg = Pagure()

    # Set the repo to create new issues against
    pg.repo=PAGURE_REPO

    # Grab messages from fedmsg and process them as we go
    for name, endpoint, topic, msg in fedmsg.tail_messages():
        if "pungi.compose.status.change" in topic and msg['msg']['status'] != 'FINISHED':

            # We have a compose that either failed or had missing artifacts
            # create a new issue.
            title = msg['msg']['compose_id'] + ' ' + msg['msg']['status']
            logfile = msg['msg']['location'] + '../logs/global/pungi.global.log'

            # pull only part of the compose ID for the tag to set
            tag = re.search('(.*)-\d{8}', msg['msg']['compose_id']).group(1)
            #TODO figure out how to set tag on an issue

            print("%s\t%s" % (title, logfile))
            pg.create_issue(title=title, content=logfile)

if __name__ == '__main__':
    main()
