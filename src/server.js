// server.js (version ESM)
import express from "express";
import multer from "multer";
import { spawn } from "child_process";
import path from "path";
import fs from "fs";
import { fileURLToPath } from "url";

// Fix pour __dirname en ESM
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = 3000;

// Dossiers
const UPLOADS_DIR = path.join(__dirname, "uploads");
const GENERATED_DIR = path.join(__dirname, "generated");

if (!fs.existsSync(UPLOADS_DIR)) fs.mkdirSync(UPLOADS_DIR);
if (!fs.existsSync(GENERATED_DIR)) fs.mkdirSync(GENERATED_DIR);

// Middleware upload
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, UPLOADS_DIR),
  filename: (req, file, cb) => cb(null, Date.now() + "-" + file.originalname),
});
const upload = multer({ storage });

// Endpoint POST
app.post("/generate", upload.single("image"), (req, res) => {
  const { number } = req.body;
  const uploadedImagePath = req.file.path;

  if (!number || !req.file) {
    return res.status(400).json({ error: "Chiffre et image obligatoires." });
  }

  const outputFileName = `gen-${Date.now()}.png`;
  const outputPath = path.join(GENERATED_DIR, outputFileName);

  // Lancer script Python
  const python = spawn("python3", ["script.py", number, uploadedImagePath, outputPath]);

  python.stdout.on("data", (data) => console.log(`stdout: ${data}`));
  python.stderr.on("data", (data) => console.error(`stderr: ${data}`));

  python.on("close", (code) => {
    if (code !== 0) {
      return res.status(500).json({ error: "Erreur du script Python." });
    }
    res.json({
      status: "OK",
      imageUrl: `/generated/${outputFileName}`,
    });
  });
});

// Servir images générées
app.use("/generated", express.static(GENERATED_DIR));

app.listen(PORT, () => {
  console.log(`✅ Server running on http://localhost:${PORT}`);
});
