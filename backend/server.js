
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
        mask,
        harmonized,
        final
    } = req.body;

    if (!source || !output || !mask || !harmonized || !final) {
        return res.status(400).send('Tous les paramètres sont requis');
    }

    const batchFile = path.join(__dirname, 'launch.bat');

    const args = [
        source,
        output,
        mask,
        harmonized,
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
        res.send(`Batch exécuté avec succès. Sortie :\n${stdout}`);
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
