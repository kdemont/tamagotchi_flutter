import base64
import json

# === CONFIG ===
INPUT_FILE = "example.json"
OUTPUT_FILE = "example.json"
FRAME_ID = "fr_1"
IMAGE_FILE = f"{FRAME_ID}.png"
# ==============

with open(INPUT_FILE, "r", encoding="utf-8") as f:
    data = json.load(f)

with open(IMAGE_FILE, "rb") as img_file:
    b64 = base64.b64encode(img_file.read()).decode("utf-8")

found = False
for asset in data.get("assets", []):
    if asset.get("id") == FRAME_ID:
        asset["p"] = f"data:image/png;base64,{b64}"
        print(f"✅ Image '{FRAME_ID}' remplacée par {IMAGE_FILE}")
        found = True
        break

if not found:
    print(f"⚠️ Aucune image trouvée avec id='{FRAME_ID}'")

with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print(f"🎨 Nouveau fichier Lottie enregistré : {OUTPUT_FILE}")
