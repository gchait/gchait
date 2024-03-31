"""
hi.
"""

from litestar import Litestar, MediaType, Request, get


@get("/")
async def index(request: Request) -> str:
    """hi."""
    print("headers:", request.headers.to_header_list())
    return "Hello, world!"


@get("/books/{book_id:int}")
async def get_book(book_id: int) -> dict[str, int]:
    """hi."""
    return {"book_id": book_id}


@get(path="/healthz", media_type=MediaType.TEXT)
async def health_check() -> str:
    """hi."""
    return "healthy"


app = Litestar([index, get_book, health_check])
