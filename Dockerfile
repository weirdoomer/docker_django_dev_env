FROM python:3.10.12-slim-bookworm as base

ARG USER
ARG UID

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt update && apt upgrade -y

RUN useradd -m -u $UID $USER

USER $USER

WORKDIR /home/$USER/app

RUN pip install --upgrade pip
COPY --chown=$USER ./app/requirements.dev.txt .
RUN pip install -r requirements.dev.txt