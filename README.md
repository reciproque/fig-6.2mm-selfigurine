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

3. Installer [Visual Studio Build Tools 2022](https://visualstudio.microsoft.com/fr/visual-cpp-build-tools/) avec le SDK Windows
   
   <img width="335" height="260" alt="image(1)" src="https://github.com/user-attachments/assets/e1b97a4d-ddfc-4915-8481-a10cf1485560" />


5. Installer [Python 3.10.0](https://www.python.org/downloads/release/python-3100/). L'ajouter au PATH et désactiver la limite de nom de fichier.

6. Vérifier que Python est bien installé. La commande :

```
python -V
```

doit bien renvoyer ```Python 3.10.0```. 

Si l'erreur ``Python est introuvable ; exécutez sans arguments, installer à partir du Microsoft Store ou désactivez ce raccourci`` apparaît : désactiver l'alias Windows en décochant Python et Python3 dans le panneau Paramètres > Applications > Paramètres avancés des applications > Alias d'exécution d'application
   
   <img width="696" height="493" alt="image" src="https://github.com/user-attachments/assets/9f8bc6b8-54c3-4c6b-a539-42cc350506a9" />



5. Ouvrir un terminal dans le dossier /roop
   
6. Créer un envionnement virtuel
```
python -m venv path-to-new-venv
```
7. Activer l'environnement virtuel path-to-new-venv/Scripts/activate
   
8. Installer les dépendances de roop ; exécuter :

```
python -m pip install -r requirements.txt
```

L'installation de toutes les dépendances peut prendre un certain temps.

9. Installer les dépendances Python du backend. Ouvrir un terminal dans le dossier /backend et exécuter :

10. **Paramétrage du navigateur** :
   - Sélectionner le dossier backend/photos comme dossier d'enregistrement par défaut des fichiers. Décocher également l'option "Toujours demander où enregistrer les fichiers".
   - Vérifier par ailleurs que le dossier backend/photos est vide et que le fichier `photo-count.txt` contient `0`.
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


## Lancement automatique
Les raccourcis  Selfigurine - 1 - Serveur (start-selfigurine-serv.bat) puis le raccourci Selfigurine - 2 - Application (start-selfigurine-app.bat) permettent de lancer l'application sans passer par un terminal.

start-selfigurine-serv.bat et start-selfigurine-app.bat sont appelées au démarrage de Windows grâce au planificateur de tâches. 

**start-selfigurine-serv.bat :**
lance le serveur en arrière-plan

**start-selfigurine-app.bat :**
lance l’application http://localhost:5173/ dans un navigateur Chrome plein écran + mode kiosque ;
désactive l’explorateur Windows afin que les visiteurs ne puissent pas quitter l’application.

**Pour quitter :**
Brancher un clavier
CTRL+ALT+SUPPR > Gestionnaire des tâches
Fichier > Exécuter une nouvelle tâche > “explorer.exe”
Quitter Chrome (app)
Quitter les consoles (serv)

