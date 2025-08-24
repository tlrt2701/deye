import os
import threading
import paho.mqtt.client as mqtt
from pymodbus.datastore import ModbusSlaveContext, ModbusServerContext
from pymodbus.datastore import ModbusSequentialDataBlock
from pymodbus.server.sync import StartTcpServer
from pymodbus.payload import BinaryPayloadBuilder, Endian

# 🔧 Konfiguration aus Umgebungsvariablen
mqtt_broker = os.getenv("MQTT_BROKER", "core-mosquitto")
mqtt_topic = os.getenv("MQTT_TOPIC", "homeassistant/sensor/go_econtroller_910332_grid_power/state")
modbus_port = int(os.getenv("MODBUS_PORT", "5020"))

# 🧠 Modbus-Speicher vorbereiten (Input Register Bereich)
store = ModbusSlaveContext(
    ir=ModbusSequentialDataBlock(0, [0] * 200),  # 200 Input-Register
    zero_mode=True
)
context = ModbusServerContext(slaves=store, single=True)

# 🔁 Funktion zum Schreiben eines Float-Werts in Modbus-Register
def set_float(context, address, value):
    builder = BinaryPayloadBuilder(byteorder=Endian.Big, wordorder=Endian.Little)
    builder.add_32bit_float(value)
    registers = builder.to_registers()
    context[0].setValues(4, address, registers)  # 4 = Input Register

# 📡 MQTT Callback
def on_message(client, userdata, msg):
    try:
        value = float(msg.payload.decode())
        set_float(context, 52, value)  # Register 52 = Active Power
        print(f"MQTT -> Modbus: {value:.2f} W geschrieben in Register 52")
    except Exception as e:
        print(f"⚠️ Fehler beim Verarbeiten der MQTT-Nachricht: {e}")

# 🚀 MQTT-Thread starten
def mqtt_loop():
    client = mqtt.Client()
    try:
        client.connect(mqtt_broker, 1883, 60)
        client.subscribe(mqtt_topic)
        client.on_message = on_message
        print(f"📡 Verbunden mit MQTT-Broker '{mqtt_broker}', lausche auf Topic '{mqtt_topic}'")
        client.loop_forever()
    except Exception as e:
        print(f"❌ MQTT-Verbindung fehlgeschlagen: {e}")

mqtt_thread = threading.Thread(target=mqtt_loop)
mqtt_thread.daemon = True
mqtt_thread.start()

# 🧱 Modbus TCP Server starten
print(f"🧰 Starte SDM630 Emulator auf Port {modbus_port}...")
StartTcpServer(context, address=("0.0.0.0", modbus_port))
