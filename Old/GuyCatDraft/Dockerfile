FROM python:3.12-alpine AS base

ARG PORT
ENV PORT ${PORT}
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PIP_DISABLE_PIP_VERSION_CHECK 1
ENV PIPENV_VENV_IN_PROJECT 1
ENV APP_DIR /appdir
ENV APP_USER appuser

FROM base AS builder
WORKDIR /
RUN pip install --no-cache-dir pipenv
COPY Pipfile* .
RUN pipenv sync

FROM base
RUN adduser -DHs /sbin/nologin -h /dev/null -g ${APP_USER} ${APP_USER}
COPY --from=builder /.venv /.venv
ENV PATH=/.venv/bin:$PATH
WORKDIR ${APP_DIR}
COPY . .

USER ${APP_USER}
EXPOSE ${PORT}
CMD ["./run.sh"]
