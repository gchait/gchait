async def call_downstream_api(
    endpoint: str, access_token: str, serialize_resp: bool = False
) -> tuple[Mapping | bytes, Mapping]:
    client = httpx_client_wrapper()
    if client is None:
        raise TypeError
    
    response = await client.get(
        url=endpoint,
        headers=fd(Authorization="Bearer " + access_token),
        timeout=20,
    )

    data = response.json() if serialize_resp else response.content
    return data, response.headers