#!/usr/bin/python3
import datetime
import fedmsg
import os
import re
import requests
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

# URL for linking to koji tasks by ID
KOJI_TASK_URL='https://koji.fedoraproject.org/koji/taskinfo?taskID='

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


def get_supporting_text(line):
    """ given a log file line determine if it has a koji task ID in it
        or not and give back an appropriate message
    """
    r = re.search('.*failed: (\d{8}).*', line)
    if r:
        taskid = r.group(1)
        text = "- [%s](%s%s)\n" % (taskid, KOJI_TASK_URL, taskid)
    else:
        text = "- No Task ID, look at log statement\n"
    return text

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

    # Used for printing out a value when the day has changed
    date = datetime.date.today()

    # Grab messages from fedmsg and process them as we go
    logger.info("Starting listening for fedmsgs..") 
    for name, endpoint, topic, msg in fedmsg.tail_messages():
        logger.debug(topic)

        # Print out a log statement if the day has changed
        today = datetime.date.today()
        if today != date:
            date = today
            logger.info('mark')

        if "pungi.compose.status.change" in topic:
            print('.', end='') # some sort of indicator of progress
            print('.') # some sort of indicator of progress

            status = msg['msg']['status']

            # If we are in good states then continue
            if status in ['FINISHED', 'STARTED']:
                continue

            # We have a compose that either failed or had missing artifacts
            # create a new issue.
            title = msg['msg']['compose_id'] + ' ' + status
            logfileurl = msg['msg']['location'] + '/../logs/global/pungi.global.log'
            logger.info("%s\t%s" % (title, logfileurl))

            # variable to hold description for issue
            content = "[pungi.global.log](%s)\n\n" % logfileurl

            # If we fail to get the log file contents then we'll just
            # best effort put a message in the issue.
            try:
                lines = requests.get(logfileurl).text.splitlines()
            except:
                logger.info("Failed to retrieve log contents from server.. skipping analysis")
                content+= "Failed to retrieve log contents from server.. skipping analysis"
                lines = []
                pass

            for x in range(1, len(lines)):
                line = lines[x-1][20:]   # trim date off log lines
                nextline = lines[x][20:] # trim date off log lines

                # If this is a [FAIL] line then we take it and the
                # next line and add them in markdown format. Also grab
                # the taskid if we can and print a hyperlink to koji
                if re.search('\[FAIL\]', line):
                    content+= get_supporting_text(nextline)
                    content+= "```\n%s\n%s\n```\n\n" % (line, nextline)

                # If this is the Compose run failed line, then add it
                # to the description too
                if re.search('.*Compose run failed.*', line):
                    content+= ("- Compose run failed because: %s\n" %
                                            get_supporting_text(line))
                    content+= "```\n%s\n```\n" % (line)

            logger.debug(content)

            # pull only part of the compose ID for the tag to set
            tag = re.search('(.*)-\d{8}', msg['msg']['compose_id']).group(1)
            #TODO figure out how to set tag on an issue

            if token:
                pg.create_issue(title=title, content=content)

if __name__ == '__main__':
    main()
