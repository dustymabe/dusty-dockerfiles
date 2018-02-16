#!/usr/bin/python3
import fedmsg
import re
import os
from libpagure import Pagure

# Set fedmsg logging to not print warnings
import logging
logger = logging.getLogger('fedmsg')
logger.setLevel(logging.ERROR)

# Set local logging 
logger = logging.getLogger(__name__)
sh = logging.StreamHandler()
sh.setFormatter(logging.Formatter('%(asctime)s %(message)s'))
logger.addHandler(sh)
logger.setLevel(logging.INFO)


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
        logger.info("Using detected token to talk to pagure.") 
        pg = Pagure(pagure_token=token)
    else:
        logger.info("No pagure token was detected.") 
        logger.info("This script will run but won't be able to create new issues.")
        pg = Pagure()

    # Set the repo to create new issues against
    pg.repo=PAGURE_REPO

    # Grab messages from fedmsg and process them as we go
    logger.info("Starting listening for fedmsgs..") 
    for name, endpoint, topic, msg in fedmsg.tail_messages():
        if "pungi.compose.status.change" in topic and msg['msg']['status'] != 'FINISHED':

            # We have a compose that either failed or had missing artifacts
            # create a new issue.
            title = msg['msg']['compose_id'] + ' ' + msg['msg']['status']
            logfileurl = msg['msg']['location'] + '/../logs/global/pungi.global.log'

            # pull only part of the compose ID for the tag to set
            tag = re.search('(.*)-\d{8}', msg['msg']['compose_id']).group(1)
            #TODO figure out how to set tag on an issue

            logger.info("%s\t%s" % (title, logfileurl))
            pg.create_issue(title=title, content=logfile)

if __name__ == '__main__':
    main()
