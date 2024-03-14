"""
Some data structures.
"""

from collections import defaultdict as dd
from decimal import Decimal

from msgspec import Struct, field


class AccountGroup(Struct):
    """Aggregate multiple AWS accounts."""

    Name: str
    Accounts: set[str]
    DailyBudget: int
    Costs: dd[str, Decimal] = field(default_factory=lambda: dd(Decimal))

    @property
    def MonthlyBudget(self) -> int:
        return self.DailyBudget * 30

    @property
    def DailyCost(self) -> Decimal:
        return next(iter(reversed(self.Costs.values())))

    @property
    def MonthlyCost(self) -> Decimal:
        return sum(self.Costs.values()) or Decimal("0")

    @property
    def DailyUsage(self) -> Decimal:
        try:
            return self.DailyCost / self.DailyBudget * Decimal("100")
        except ZeroDivisionError:
            return Decimal("inf")

    @property
    def MonthlyUsage(self) -> Decimal:
        try:
            return self.MonthlyCost / self.MonthlyBudget * Decimal("100")
        except ZeroDivisionError:
            return Decimal("inf")


class Settings(Struct):
    """Program configuration."""

    sender_email: str
    email_subject: str
    recipient_emails: tuple[str, ...]
    account_groups: list[AccountGroup]


"""
Gets the daily costs of all relevant accounts and sends them in an email.
"""

from copy import deepcopy
from datetime import datetime, timedelta
from decimal import Decimal
from os.path import abspath, dirname

import msgspec
from boto3 import client as aws
from jinja2 import Environment, FileSystemLoader

from .models import AccountGroup, Settings

AWS_DATE_FORMAT = "%Y-%m-%d"

others_acc_group = AccountGroup(Name="Other", DailyBudget=123456789, Accounts=set())
ssm_param = aws("ssm").get_parameter(Name="xxx", WithDecryption=True)
raw_settings = ssm_param["Parameter"]["Value"]
cfg = msgspec.yaml.decode(raw_settings, type=Settings)
acc_groups = deepcopy(cfg.account_groups)


def find_account_group_by_id(acc_id: str) -> AccountGroup:
    """Descend the lists to find which account group an account belongs to."""
    for acc_group in acc_groups:
        if acc_id in acc_group.Accounts:
            return acc_group
    return others_acc_group


def fill_costs() -> None:
    """Use Cost Explorer to populate the accounts' costs."""
    ce = aws("ce")
    yesterday = datetime.now() - timedelta(days=1)
    month_start = yesterday.replace(day=1)

    if yesterday == month_start:
        month_start = month_start - timedelta(days=1)

    start_date = month_start.strftime(AWS_DATE_FORMAT)
    end_date = yesterday.strftime(AWS_DATE_FORMAT)

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
            date = result["TimePeriod"]["Start"]
            cost = Decimal(group["Metrics"]["AmortizedCost"]["Amount"])
            account_group.Costs[date] += cost

            if account_group.Name == others_acc_group.Name:
                others_acc_group.Accounts.add(account_id)
    acc_groups.append(others_acc_group)


def send_email() -> None:
    """Template the email with Jinja2 and send it to the recipients using SES."""
    ses = aws("ses")
    environment = Environment(
        loader=FileSystemLoader(abspath(dirname(__file__))),
        autoescape=True,
    )
    template = environment.get_template("email.html.j2")
    email_body = template.render(account_groups=acc_groups)

    ses.send_email(
        Source=cfg.sender_email,
        Destination={"ToAddresses": cfg.recipient_emails},
        Message={
            "Subject": {"Data": cfg.email_subject},
            "Body": {"Html": {"Data": email_body}},
        },
    )


if __name__ == "__main__":
    fill_costs()
    send_email()
