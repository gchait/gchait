async def get_costs(
    start_date: str,
    end_date: str,
    by_tags: tuple,
    filters: CostExplorerFilter | None = None,
) -> dict[str, list[dict[str, float]]]:
    """Extract and transform the cloud costs between given days."""
    # pylint: disable=too-many-locals

    filter_by = fd(Filter=filters.filter) if filters else fd()
    response = ce_client.get_cost_and_usage(
        TimePeriod=fd(Start=start_date, End=end_date),
        Granularity="DAILY",
        Metrics=("UnblendedCost",),
        GroupBy=[fd(Type="TAG", Key=tag) for tag in by_tags],
        **filter_by,
    )

    logger.info(
        "Received the costs of %s for %s - %s%s.",
        " & ".join(by_tags),
        start_date,
        end_date,
        f" with a filter for {filters.name}" if filters else "",
    )

    cost_data = defaultdict(list)
    for group in response["ResultsByTime"]:
        for cost in group["Groups"]:
            subject_items = []
            for key, value in zip(by_tags, cost["Keys"]):
                subject_items.append(value.removeprefix(f"{key}$"))

            subject = "_".join(subject_items)
            cost_amount = round(float(cost["Metrics"]["UnblendedCost"]["Amount"]), 2)
            date = group["TimePeriod"]["Start"]

            if cost_data[subject] and date == cost_data[subject][-1]["date"]:
                cost_data[subject][-1]["cost"] = float(
                    deci(cost_data[subject][-1]["cost"]) + deci(cost_amount)
                )
            else:
                cost_data[subject].append({"date": date, "cost": cost_amount})

    for items in cost_data.values():
        # Check that dates are not repeated
        if Counter([item["date"] for item in items]).most_common(1)[0][1] > 1:
            logger.critical("Algorithm is broken, duplicate dates found.")
            raise AssertionError
    return cost_data


async def get_cost_sums(**kwargs) -> dict[str, Decimal]:
    """For things that don't care about each individual day and just want the totals."""
    all_costs = await get_costs(**kwargs)
    cost_sums = defaultdict(Decimal)

    for env, costs in all_costs.items():
        for item in costs:
            cost_sums[env] += deci(item["cost"])
    return cost_sums