import argparse
from PIL import Image
import numpy as np

# === ARGUMENT PARSING ===
parser = argparse.ArgumentParser(description="Harmonize output image with skin tone from source image using a mask.")
parser.add_argument("-p", "--photo", required=True, help="Path to the source image (e.g., webcam photo).")
parser.add_argument("-f", "--fig", required=True, help="Path to the figurine image to be harmonized.")
parser.add_argument("-m", "--mask", required=True, help="Path to the grayscale mask image.")
parser.add_argument("-s", "--save_path", required=True, help="Path to save the harmonized image.")
parser.add_argument("-b", "--blend_strength", type=float, default=0.1, help="Blending strength between 0 and 1 (default: 0.5)")

args = parser.parse_args()

SOURCE_IMAGE = args.photo
OUTPUT_IMAGE = args.fig
MASK_IMAGE = args.mask
OUTPUT_PATH = args.save_path
BLEND_STRENGTH = args.blend_strength

# === LOAD IMAGES ===
source = Image.open(SOURCE_IMAGE).convert("RGB")
output = Image.open(OUTPUT_IMAGE).convert("RGB")
mask = Image.open(MASK_IMAGE).convert("L")  

# Resize mask to match output image size (if needed)
if mask.size != output.size:
    mask = mask.resize(output.size)

# Convert to numpy arrays
source_np = np.array(source)
output_np = np.array(output)
mask_np = np.array(mask) / 255.0  # Normalize mask to [0, 1]

# === Get average color from center of source image ===
def get_average_color(img_np):
    h, w, _ = img_np.shape
    center = img_np[h//4:3*h//4, w//4:3*w//4]
    return np.mean(center.reshape(-1, 3), axis=0)

skin_color = get_average_color(source_np)

# === Blend skin color into output using mask ===
harmonized_np = output_np.copy()

for c in range(3):  # R, G, B
    harmonized_np[..., c] = (
        output_np[..., c] * (1 - BLEND_STRENGTH * mask_np) +
        skin_color[c] * (BLEND_STRENGTH * mask_np)
    )

# Clip and convert
harmonized_np = np.clip(harmonized_np, 0, 255).astype(np.uint8)
harmonized_img = Image.fromarray(harmonized_np)
harmonized_img.save(OUTPUT_PATH)

print(f"Harmonized image saved to {OUTPUT_PATH}")
