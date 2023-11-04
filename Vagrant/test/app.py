# pylint: disable=missing-module-docstring,missing-function-docstring

from fastapi import FastAPI, Request, Response
from fastapi.templating import Jinja2Templates
from uvicorn import run

app = FastAPI()
TemplateResponse = Jinja2Templates(directory=".").TemplateResponse


@app.get("/")
async def index(request: Request) -> Response:
    context = {
        "request": request,
        "title": "Vue.js CDN PoC",
        "jinja_name": "Jinja",
        "jinja_message": "Hello from Jinja2!",
    }
    return TemplateResponse(name="index.html", context=context)


if __name__ == "__main__":
    run("app:app", host="0.0.0.0", port=8080, reload=True)  # nosec
