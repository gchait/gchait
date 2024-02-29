async def send_email(subject: str, html_body: str) -> None:
    """Send an email to the configured addresses using Amazon SES."""
    message_id = ses_client.send_email(
        Source="xxxxxxxx",
        Destination=fd(ToAddresses=email_receivers),
        Message=fd(
            Subject=fd(Data=subject),
            Body=fd(Html=fd(Data=html_body)),
        },
    ).get("MessageId", "")

    if not message_id:
        logger.error("Missing message ID after sending an email.")
        raise LookupError
    logger.info("Email sent! Message ID: %s", message_id)
