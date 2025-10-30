
import fs from 'fs/promises';
import path from 'path';
import express from 'express';
import cors from 'cors';
import { fileURLToPath } from 'url';
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
import { execFile } from 'child_process';

const app = express();
const PORT = 3000;

app.use(express.json());
app.use(cors());

const compteurPath = path.join(__dirname, 'photos/photo-count.txt');

app.post('/run', (req, res) => {
  const {
    source,
    output,
    final
  } = req.body;

  if (!source || !output || !final) {
    return res.status(400).send('Tous les paramètres sont requis');
  }

  const batchFile = path.join(__dirname, 'launch.bat');

  const args = [
    source,
    output,
    final
  ];

  execFile(batchFile, args, { shell: true }, (error, stdout, stderr) => {
    if (error) {
      console.error(`Erreur batch : ${error.message}`);
      return res.status(500).send(`Erreur : ${error.message}`);
    }

    if (stderr) {
      console.error(`stderr : ${stderr}`);
    }

    console.log(`stdout : ${stdout}`);

    if (stdout.includes('All done.')) {
      res.status(200).json({
        success: true,
        message: 'Batch terminé avec succès',
        finalImagePath: final
      });
    } else {
      res.status(200).json({
        success: false,
        message: 'Batch terminé, mais pas de confirmation "All done."',
        rawOutput: stdout
      });
    }
  });
});


app.get('/compteur', async (req, res) => {
  try {
    const data = await fs.readFile(compteurPath, 'utf8');
    const count = parseInt(data, 10) || 0;
    res.json({ count });
  } catch (err) {
    res.status(500).json({ error: 'Impossible de lire le compteur.' });
  }
});

app.post('/compteur/increment', async (req, res) => {
  try {
    const data = await fs.readFile(compteurPath, 'utf8');
    const count = parseInt(data, 10) || 0;
    const newCount = count + 1;
    await fs.writeFile(compteurPath, String(newCount), 'utf8');
    res.json({ count: newCount });
  } catch (err) {
    res.status(500).json({ error: 'Impossible de mettre à jour le compteur.' });
  }
});


app.listen(PORT, () => {
  console.log(`Serveur lancé sur http://localhost:${PORT}`);
});


import Client from 'ftp';


app.post('/upload', (req, res) => {
  const c = new Client();
  let responseSent = false;

  const localFile = path.join(__dirname, 'text.txt');
  const remoteFile = '/selfigurine/text.remote.txt';

  console.log('➡️ Tentative FTP vers', localFile);

  function sendResponseOnce(status, data) {
    if (!responseSent) {
      responseSent = true;
      res.status(status).json(data);
    } else {
    }
  }

  c.on('ready', () => {
    console.log('✅ Connexion FTP établie.');
    c.put(localFile, remoteFile, (err) => {
      c.end();

      if (err) {
        console.error('❌ Erreur upload FTP:', err.message);
        return sendResponseOnce(500, { success: false, error: err.message });
      }

      console.log(`📤 Fichier ${localFile} envoyé en ${remoteFile}`);
      sendResponseOnce(200, { success: true, message: 'Upload réussi' });
    });
  });

  c.on('error', (err) => {
    console.error('❌ Erreur FTP:', err.message);
    c.end();
    sendResponseOnce(500, { success: false, error: 'Erreur FTP: ' + err.message });
  });

  c.on('end', () => {
    console.log('🔚 Connexion FTP fermée.');
  });


  c.connect({
    host: 'selfigurine.musees-compiegne.fr',
    user: 'reciproque@selfigurine.musees-compiegne.fr',
    password: '!RHY99@GUL!%1j',
    secure: true,
    secureOptions: { rejectUnauthorized: false },
    connTimeout: 10000,
    pasvTimeout: 10000
  });
});
