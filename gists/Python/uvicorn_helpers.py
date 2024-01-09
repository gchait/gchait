async def kill_app() -> None:
    """Kill the uvicorn processes to force an application shutdown."""
    await sleep(2)
    parent = Process(getpid())
    for child in parent.children(recursive=True):
        child.kill()
    parent.kill()
    
    
class EndpointFilter(Filter):
    """A generic way to filter out web endpoints from the logs."""

    # pylint: disable=too-few-public-methods

    def __init__(
        self,
        path: str,
        *args,
        **kwargs,
    ):
        super().__init__(*args, **kwargs)
        self._path = path

    def filter(self, record: LogRecord) -> bool:
        return record.getMessage().find(self._path) == -1


# Tap into the default uvicorn log stream and manipulate it
logger = getLogger("uvicorn")
uvicorn_access_logger = getLogger("uvicorn.access")
uvicorn_access_logger.addFilter(EndpointFilter(path=HEALTHCHECK_URI))
