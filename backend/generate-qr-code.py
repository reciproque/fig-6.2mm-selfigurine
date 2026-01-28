import csv
import qrcode
from PIL import Image
import os
import argparse

# Créer un parseur
parser = argparse.ArgumentParser(description="Traitement d’un fichier d’entrée.")

# Ajouter un argument positionnel obligatoire
parser.add_argument("filename", help="Chemin du fichier à traiter")

# Parser les arguments
args = parser.parse_args()

# Utiliser l'argument
print(f"Fichier reçu : {args.filename}")

QR_SIZE_PX = 250 
BOX_SIZE = 10     
BORDER = 4        

def generate_qr(url):
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_H,
        box_size=BOX_SIZE,
        border=BORDER,
    )
    qr.add_data(url)
    qr.make(fit=True)
    img = qr.make_image(fill_color="black", back_color="#ffc759").convert("RGB")
    img = img.resize((QR_SIZE_PX, QR_SIZE_PX), Image.LANCZOS)
    return img

def clean_filename(name):
    return "".join(c if c.isalnum() or c in "-_." else "_" for c in name)


name = args.filename
url = "https://selfigurine.musees-compiegne.fr/selfigurine/"+args.filename+".png"
qr_img = generate_qr(url)
filename = f"{name}.png"
qr_img.save("qrcodes/"+filename)
print(f"QR code généré : {filename}")