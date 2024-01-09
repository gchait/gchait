"""
This simply functions as a reverse-proxy to a Jenkins job.
It allows granting the source access only to this specific action,
instead of requiring direct network access to the Jenkins server.
"""

from os import getenv
from urllib.request import Request, urlopen

JENKINS_URL = "https://PLACEHOLDER"
JOB_URI = "/buildByToken/buildWithParameters?job=PLACEHOLDER&token={}"

HEADERS = {"Content-Type": "application/json", "Accept": "application/json"}
METHOD = "POST"


def lambda_handler(event, _):
    """Build the job, using event items as the params."""
    url = JENKINS_URL + JOB_URI.format(getenv("TOKEN"))
    for key, val in event.items():
        url += f"&{key}={val}"

    response = urlopen(Request(url=url, headers=HEADERS, method=METHOD), timeout=10)

    if response.status == 201:
        return {"statusCode": 200, "body": "Jenkins job triggered successfully."}

    return {"statusCode": response.status, "body": "Failed to trigger Jenkins job."}
