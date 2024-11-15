FROM python:3.13.0-alpine3.20

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.text /tmp/requirements.dev.txt
COPY ./app /app

WORKDIR /app

ARG DEV=false

RUN <<EOF
    python -m venv /py
    /py/bin/pip install --upgrade pip
    apk add --update --no-cache --virtual .build-deps build-base musl-dev python3-dev linux-headers
    /py/bin/pip install -r /tmp/requirements.txt
    if [ "$DEV" = "true" ]; then
        /py/bin/pip install -r /tmp/requirements.dev.txt
    fi
    rm -rf /tmp
    apk del .build-deps
    adduser --disabled-password app-user
EOF

ENV PATH="/py/bin:$PATH"

USER app-user