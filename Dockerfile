ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-addon-base:14.3.2
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Python + pip
RUN apk add --no-cache python3 py3-pip

# venv optional, kann man machen
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt

COPY run.sh /
COPY sdm630_emulator.py /sdm630_emulator.py
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
