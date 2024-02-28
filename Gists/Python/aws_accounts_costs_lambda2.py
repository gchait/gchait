#!/usr/bin/env python
"""
Gets the daily costs of all relevant accounts and sends them in an email.
"""

from datetime import datetime, timedelta
from decimal import Decimal
from typing import Any, Optional

from boto3 import client as aws
from jinja2 import Environment, FileSystemLoader

from models import AccountGroup
from settings import EMAIL_SUBJECT, RECIPIENT_EMAILS, SENDER_EMAIL, account_groups

AWS_DATE_FORMAT = "%Y-%m-%d"


def find_account_group_by_id(acc_id: str) -> Optional[AccountGroup]:
    """Descend the lists to find which account group an account belongs to."""
    for acc_group in account_groups:
        if acc_id in acc_group.Accounts:
            return acc_group


def fill_costs() -> None:
    """Use Cost Explorer to get the account costs of 2 days ago."""
    ce = aws("ce")
    end = datetime.now() - timedelta(days=1)
    start = end - timedelta(days=1)
    start_date = start.strftime(AWS_DATE_FORMAT)
    end_date = end.strftime(AWS_DATE_FORMAT)

    response = ce.get_cost_and_usage(
        TimePeriod={"Start": start_date, "End": end_date},
        Granularity="DAILY",
        Metrics=["AmortizedCost"],
        GroupBy=[{"Type": "DIMENSION", "Key": "LINKED_ACCOUNT"}],
        Filter={"Not": {"Dimensions": {"Key": "RECORD_TYPE", "Values": ["Tax"]}}},
    )

    for result in response["ResultsByTime"]:
        for group in result["Groups"]:
            account_id = group["Keys"][0]
            account_group = find_account_group_by_id(account_id)

            if not account_group:
                continue

            cost = Decimal(group["Metrics"]["AmortizedCost"]["Amount"])
            account_group.Cost += cost

    for acc_group in account_groups:
        try:
            acc_group.Usage = acc_group.Cost / acc_group.Budget * Decimal("100")
        except ZeroDivisionError:
            acc_group.Usage = Decimal("inf")


def send_email() -> None:
    """Template the email with Jinja2 and send it to the recipients using SES."""
    ses = aws("ses")
    environment = Environment(loader=FileSystemLoader("."), autoescape=True)
    template = environment.get_template("email.html.j2")
    email_body = template.render(account_groups=account_groups)

    ses.send_email(
        Source=SENDER_EMAIL,
        Destination={"ToAddresses": RECIPIENT_EMAILS},
        Message={
            "Subject": {"Data": EMAIL_SUBJECT},
            "Body": {"Html": {"Data": email_body}},
        },
    )


def handler(_: Any = None, __: Any = None) -> None:
    """The entry-point of the AWS Lambda, runs the program."""
    fill_costs()
    send_email()


if __name__ == "__main__":
    handler()
