#!/usr/bin/env python
"""
Gets the daily costs of all relevant accounts and sends them in an email.
"""

from collections import OrderedDict
from datetime import datetime, timedelta
from decimal import Decimal

from boto3 import client as aws
from jinja2 import Environment, FileSystemLoader

from settings import ACCOUNT_GROUPS, EMAIL_SUBJECT, RECIPIENT_EMAILS, SENDER_EMAIL

AWS_DATE_FORMAT = "%Y-%m-%d"
ZERO = Decimal("0")
HUNDRED = Decimal("100")

CostsModel = OrderedDict[str, OrderedDict[str, Decimal]]
DatesModel = list[str]


class SuperOrderedDict(OrderedDict):
    """An OrderedDict with OrderedDict values."""

    def __missing__(self, key) -> OrderedDict:
        """Missing keys are auto-created with a ready OrderedDict."""
        value = OrderedDict()
        self[key] = value
        return value


def get_dates_and_costs() -> tuple[DatesModel, CostsModel]:
    """Use Cost Explorer to get the account costs of the previous 2 days."""
    ce = aws("ce")
    end = datetime.now()
    start = end - timedelta(days=2)
    start_date = start.strftime(AWS_DATE_FORMAT)
    end_date = end.strftime(AWS_DATE_FORMAT)

    response = ce.get_cost_and_usage(
        TimePeriod={"Start": start_date, "End": end_date},
        Granularity="DAILY",
        Metrics=["AmortizedCost"],
        GroupBy=[{"Type": "DIMENSION", "Key": "LINKED_ACCOUNT"}],
        Filter={"Not": {"Dimensions": {"Key": "RECORD_TYPE", "Values": ["Tax"]}}},
    )

    dates = set()
    costs = SuperOrderedDict()

    for result in response["ResultsByTime"]:
        for group in result["Groups"]:
            account_id = group["Keys"][0]
            if account_id not in ACCOUNT_GROUPS:
                continue

            name = ACCOUNT_GROUPS[account_id]
            cost = round(Decimal(group["Metrics"]["AmortizedCost"]["Amount"]), 2)
            date = result["TimePeriod"]["Start"]

            dates.add(date)
            costs[name][date] = costs[name].setdefault(date, ZERO) + cost

    for name in list(costs):
        iter_costs = iter(costs[name].values())
        first, second = next(iter_costs), next(iter_costs)

        try:
            costs[name]["Diff"] = round(((second - first) / first) * HUNDRED, 2)
        except ZeroDivisionError:
            costs[name]["Diff"] = HUNDRED

    return sorted(dates), costs


def send_email(dates: DatesModel, costs: CostsModel) -> None:
    """Template the email with Jinja2 and send it to the recipients using SES."""
    ses = aws("ses")
    template = Environment(
        loader=FileSystemLoader("."),
        autoescape=True,
    ).get_template("email.html.j2")

    email_body = template.render(
        dates=dates,
        costs=costs,
    )

    ses.send_email(
        Source=SENDER_EMAIL,
        Destination={"ToAddresses": RECIPIENT_EMAILS},
        Message={
            "Subject": {"Data": EMAIL_SUBJECT},
            "Body": {"Html": {"Data": email_body}},
        },
    )


def handler(_, __) -> None:
    """The entry-point of the AWS Lambda, runs the program."""
    send_email(*get_dates_and_costs())


if __name__ == "__main__":
    handler(None, None)
