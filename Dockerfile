# 📦 Basis-Image für Home Assistant Add-ons
ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base:3.14
FROM $BUILD_FROM

# 🌍 Spracheinstellung
ENV LANG C.UTF-8

# 🛠️ Systempakete installieren
RUN apk add --no-cache python3 py3-pip

# 📜 Anforderungen installieren (direkt ins System, keine venv!)
COPY requirements.txt /requirements.txt
RUN pip3 install --no-cache-dir -r /requirements.txt

# 📁 Skripte kopieren
COPY run.sh /run.sh
COPY sdm630_emulator.py /sdm630_emulator.py

# 🔐 Ausführbarkeit sicherstellen
RUN chmod +x /run.sh

# 🚀 Startbefehl definieren (run.sh wird als PID 1 ausgeführt)
CMD [ "/run.sh" ]
