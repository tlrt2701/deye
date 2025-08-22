# Startet mit dem Basis-Image
ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base:3.14
FROM $BUILD_FROM

# Setzt die Umgebungsvariable für die Sprache
ENV LANG C.UTF-8

# Installiert Python und pip über den System-Paketmanager
RUN apk add --no-cache python3 py3-pip

# --- WICHTIGE ÄNDERUNGEN HIER ---
# Erstellt eine virtuelle Umgebung, um Konflikte zu vermeiden
RUN python3 -m venv /opt/venv

# Setzt den PATH so, dass die Befehle aus der virtuellen Umgebung verwendet werden
ENV PATH="/opt/venv/bin:$PATH"

# Kopiert die Anforderungen und installiert sie innerhalb der virtuellen Umgebung
COPY requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt
# --- ENDE DER WICHTIGEN ÄNDERUNGEN ---

# Kopiert die Skripte und macht sie ausführbar
COPY run.sh /
COPY sdm630_emulator.py /sdm630_emulator.py
RUN chmod a+x /run.sh

# Definiert den Befehl zum Starten der Anwendung
CMD [ "/run.sh" ]
