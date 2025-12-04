from PIL import Image

import sys

input_file = sys.argv[1]
overlay_file = sys.argv[2]
output_file = sys.argv[3]

base = Image.open(input_file).convert("RGBA")
overlay = Image.open(overlay_file).convert("RGBA")

position = (base.width - overlay.width - 20, base.height - overlay.height - 20)

base.paste(overlay, position, overlay)
base.save(output_file)
