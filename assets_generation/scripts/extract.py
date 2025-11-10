import base64
import io
import json
from PIL import Image

# === CONFIG ===
INPUT_FILE = "example.json"
FRAME_ID = "fr_1"
OUTPUT_PNG = f"{FRAME_ID}.png"
# ==============

with open(INPUT_FILE, "r", encoding="utf-8") as f:
    data = json.load(f)

found = False
for asset in data.get("assets", []):
    if asset.get("id") == FRAME_ID and "base64" in asset.get("p", ""):
        b64 = asset["p"].split("base64,")[1]
        image_bytes = base64.b64decode(b64)
        image = Image.open(io.BytesIO(image_bytes))
        image.save(OUTPUT_PNG)
        print(f"✅ Image extraite : {OUTPUT_PNG}")
        found = True
        break

if not found:
    print(f"⚠️ Aucune image trouvée avec id='{FRAME_ID}'")
