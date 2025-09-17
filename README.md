# Selfigurine (6.2-MM - Constituer sa propre figurine)

## Pré-requis

1. Installer Node.js

2. Installer les dépendances. Ouvrir un terminal à la racine (selfigurine)

Une fois pour le front  :
```
npm install
```
Une fois pour le back :
```
cd src/backend
```
```
npm install
```

3. TODO : Documentation installation roop et dépendances Python

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
