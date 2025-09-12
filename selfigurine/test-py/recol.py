from PIL import Image
import numpy as np
from skimage.exposure import match_histograms

def recolor_body_to_face(final_img_path, face_img_path, output_path):
    # Charger les deux images
    final_img = np.array(Image.open(final_img_path).convert("RGB")) / 255.0
    face_img = np.array(Image.open(face_img_path).convert("RGB")) / 255.0

    # Transfert d’histogramme (aligne les couleurs du corps sur le visage)
    matched = match_histograms(final_img, face_img, channel_axis=-1)

    # Sauvegarde
    out = Image.fromarray((matched * 255).astype(np.uint8))
    out.save(output_path)

# Exemple d’utilisation :
# recolor_body_to_face("roop_output.jpg", "face_source.jpg", "final_corrected.jpg")
