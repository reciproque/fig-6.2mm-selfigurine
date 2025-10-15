# Selfigurine (6.2-MM - Constituer sa propre figurine)

1. Cloner le dépôt

2. Cloner le dépôt [roop](https://github.com/s0md3v/roop/) dans le répertoire /backend

## Pré-requis

1. Installer Node.js

2. Installer les dépendances du projet Node. Ouvrir un terminal à la racine (selfigurine)

Une fois pour le front  :
```
npm install
```
Une fois pour le back :
```
cd backend
```
```
npm install
```

3. Installer Python 3.10.0. L'ajouter au PATH et désactiver la limite de nom de fichier.
   
4. Si l'erreur ``Python est introuvable ; exécutez sans arguments, installer à partir du Microsoft Store ou désactivez ce raccourci`` apparaît : désactiver l'alias Windows en décochant Python et Python3 dans le panneau Paramètres > Applications > Paramètres avancés des applications > Alias d'exécution d'application
   
   <img width="696" height="493" alt="image" src="https://github.com/user-attachments/assets/9f8bc6b8-54c3-4c6b-a539-42cc350506a9" />

5. Vérifier que Python est bien installé. La commande :

```
python -V
```

doit bien renvoyer ```Python 3.10.0```.

5. Installer les dépendances Python de roop. Ouvrir un terminal dans le dossier /roop et exécuter :

```
python -m pip install -r requirements.txt
```

L'installation peut prendre un moment.

6. Installer les dépendances Python du backend. Ouvrir un terminal dans le dossier /backend et exécuter :
   

5. **Paramétrage du navigateur** :
   - Sélectionner le dossier backend/photos comme dossier d'enregistrement par défaut des fichiers. Décocher également l'option "Toujours demander où enregistrer les fichiers".
   - La première fois : autoriser l'utilisation de la webcam par le navigateur. Sélectionner la Logitech BRIO. Cocher l'option "Se souvenir de mon choix".

## Lancement manuel de l’application

1. La commande suivante démarre le backend + le frontend. À la racine (selfigurine) :
```
npm run app
```

NB : cette commande équivaut à lancer le frontend et le backend de manière simultanée (concurrently) telle que : 
```
 "scripts": {
   "frontend": "vite",
   "backend": "node backend/server.js",
   "app": "concurrently \"npm run frontend\" \"npm run backend\""
 }
```

2. Ouvrir un navigateur et accéder à l’adresse locale (par défaut : port 5173) : http://localhost:5173/ 

* Le serveur backend quant à lui tourne sur le port 3000.

3. Pour terminer les deux serveurs, dans le terminal : CTRL + C  2 fois de suite (ou CTRL + C puis "O")

4. Fermer ensuite le navigateur.
