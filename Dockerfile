ARG PYTHON_VERSION=3.10

FROM python:${PYTHON_VERSION}-slim-buster AS base

ENV \
    # do not buffer python output at all
    PYTHONUNBUFFERED=1 \
    # do not write `__pycache__` bytecode
    PYTHONDONTWRITEBYTECODE=1 \
    APP_DIR="/code"

FROM base as python-deps

ENV \
    # do not ask any interactive question
    POETRY_NO_INTERACTION=1 \
    # Poetry bin
    PATH="/root/.local/bin:${PATH}" \
    # Poetry version
    POETRY_VERSION=1.1.13

RUN apt-get -y update \
    && apt-get install -y --no-install-recommends curl \
    && apt-get -y auto-remove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/share/doc/ \
    && rm -rf /usr/share/man/ \
    && rm -rf /usr/share/locale/

RUN BIN="/usr/local/bin" && \
VERSION="1.10.0" && \
  curl -sSL \
    "https://github.com/bufbuild/buf/releases/download/v${VERSION}/buf-$(uname -s)-$(uname -m)" \
    -o "${BIN}/buf" && \
  chmod +x "${BIN}/buf"

RUN curl -sSL https://install.python-poetry.org | python3 - && \
    poetry config virtualenvs.create true && \
    poetry config virtualenvs.in-project true

WORKDIR ${APP_DIR}

COPY protos/ ${APP_DIR}/protos/
COPY buf.gen.yaml buf.work.yaml ${APP_DIR}/
COPY pyproject.toml poetry.lock ${APP_DIR}/

RUN buf generate
RUN poetry install --no-dev --no-root

## Runtime image, only copies the venv
FROM base

ARG VERSION="unknown"

COPY --from=python-deps ${APP_DIR}/.venv ${APP_DIR}/.venv/

ENV \
    PATH=${APP_DIR}/.venv/bin:$PATH \
    VERSION=$VERSION

COPY . ${APP_DIR}
WORKDIR ${APP_DIR}

CMD ["python", "app"]
