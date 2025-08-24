ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base:3.14
FROM $BUILD_FROM

ENV LANG=C.UTF-8

# Systempakete installieren
RUN apk add --no-cache python3 py3-pip

# Virtuelle Umgebung erstellen
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Python-Abhängigkeiten installieren
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

# Skripte kopieren
COPY run.sh /run.sh
COPY sdm630_emulator.py /sdm630_emulator.py
RUN chmod +x /run.sh

# Startbefehl
CMD [ "/run.sh" ]
