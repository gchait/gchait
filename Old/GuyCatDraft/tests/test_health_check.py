"""
hi.
"""

import pytest
from litestar.status_codes import HTTP_200_OK
from litestar.testing import AsyncTestClient

from guyc_at.main import app


@pytest.fixture(scope="function")
def test_client() -> AsyncTestClient:
    """hi."""
    return AsyncTestClient(app=app)


async def test_health_check(test_client: AsyncTestClient) -> None:
    """hi."""
    async with test_client as client:
        response = await client.get("/healthz")
        assert response.status_code == HTTP_200_OK
        assert response.text == "healthy"
