#!/usr/bin/env python3
import base64
import io
import json
import numpy as np
from PIL import Image

# === CONFIG ===
INPUT_FILE = "example.json"
OUTPUT_FILE = "example_with_removed_bg_and_watermark.json"
WHITE_THRESHOLD = 150  # seuil pour considérer un pixel comme "blanc"
SOFT_EDGE = True       # applique un dégradé doux au bord du fond
# =================

def decode_image_from_data_uri(data_uri: str):
    if "," not in data_uri:
        raise ValueError("Data URI invalide")
    _, b64 = data_uri.split(",", 1)
    return base64.b64decode(b64)

def encode_image_to_data_uri(img: Image.Image) -> str:
    buffered = io.BytesIO()
    img.save(buffered, format="PNG")
    b64 = base64.b64encode(buffered.getvalue()).decode("utf-8")
    return f"data:image/png;base64,{b64}"

def remove_white_background_smart(img_bytes: bytes, threshold=245, soft_edge=True):
    """Supprime le fond blanc uniquement connecté aux bords (préserve les blancs internes)."""
    img = Image.open(io.BytesIO(img_bytes)).convert("RGBA")
    arr = np.array(img)
    h, w, _ = arr.shape

    # masque des pixels "blancs"
    luminance = 0.299*arr[:,:,0] + 0.587*arr[:,:,1] + 0.114*arr[:,:,2]
    white_mask = luminance > threshold

    # flood fill depuis les bords pour identifier les zones extérieures
    visited = np.zeros((h, w), dtype=bool)
    from collections import deque
    q = deque()

    # initialisation : tous les pixels blancs du bord
    for x in range(w):
        if white_mask[0, x]: q.append((0, x))
        if white_mask[h-1, x]: q.append((h-1, x))
    for y in range(h):
        if white_mask[y, 0]: q.append((y, 0))
        if white_mask[y, w-1]: q.append((y, w-1))

    while q:
        y, x = q.popleft()
        if not (0 <= x < w and 0 <= y < h): continue
        if visited[y, x] or not white_mask[y, x]: continue
        visited[y, x] = True
        for dy, dx in [(-1,0),(1,0),(0,-1),(0,1)]:
            ny, nx = y+dy, x+dx
            if 0 <= ny < h and 0 <= nx < w and not visited[ny, nx]:
                if white_mask[ny, nx]:
                    q.append((ny, nx))

    # visited = fond connecté aux bords
    alpha = arr[:,:,3].astype(np.float32)
    if soft_edge:
        # Dégradé doux autour du bord du masque
        import cv2
        border = visited.astype(np.uint8)
        dist = cv2.distanceTransform(1 - border, cv2.DIST_L2, 3)
        fade_zone = np.clip(dist / 5.0, 0, 1)  # 5px de transition
        alpha = alpha * fade_zone

    arr[:,:,3] = np.where(visited, alpha * 0, alpha)  # rend transparent le fond externe
    return Image.fromarray(arr.astype(np.uint8), "RGBA")

def main():
    with open(INPUT_FILE, "r", encoding="utf-8") as f:
        data = json.load(f)

    count = 0
    for asset in data.get("assets", []):
        p = asset.get("p")
        if not p or "base64" not in p:
            continue
        print(f"→ Traitement de l’asset {asset.get('id','?')} ...")
        img_bytes = decode_image_from_data_uri(p)
        img_clean = remove_white_background_smart(img_bytes, threshold=WHITE_THRESHOLD, soft_edge=SOFT_EDGE)
        new_data_uri = encode_image_to_data_uri(img_clean)
        asset["p"] = new_data_uri
        count += 1

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print(f"✅ {count} image(s) traitée(s) et sauvegardées dans {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
