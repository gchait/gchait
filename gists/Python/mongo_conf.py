mongo_tls = getenv("MONGO_TLS", None) == "true"
mongo_config = fd(
    host=getenv("MONGO_HOST", "mongodb"),
    username=getenv("MONGO_USER", None),
    password=getenv("MONGO_PASS", None),
    tls=mongo_tls,
    tlsCAFile=certs_where() if mongo_tls else None,
    retryWrites=False,
)
