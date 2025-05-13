const express = require("express");
const { PrismaClient } = require("@prisma/client");
const multer = require("multer");
const fs = require("fs");
const path = require("path");
const { createClient } = require("@supabase/supabase-js");
require("dotenv").config();

const app = express();
const prisma = new PrismaClient();
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_KEY
);

app.use(express.json());

const storage = multer.memoryStorage();
const upload = multer({ storage });

// Helper: Upload file ke Supabase
const uploadToSupabase = async (file, folder) => {
  const timestamp = Date.now();
  const fileExt = path.extname(file.originalname);
  const fileName = `${folder}/${timestamp}-${file.originalname}`;

  const { data, error } = await supabase.storage
    .from("uploads")
    .upload(fileName, file.buffer, {
      contentType: file.mimetype,
      upsert: true,
    });

  if (error) throw new Error("Gagal upload ke Supabase: " + error.message);

  const { data: publicUrl } = supabase.storage
    .from("uploads")
    .getPublicUrl(fileName);
  return publicUrl.publicUrl;
};

// =============== SURAT MASUK ===============

app.get("/api/surat-masuk", async (req, res) => {
  const result = await prisma.suratMasuk.findMany();
  res.json(result);
});

app.post("/api/surat-masuk", upload.single("file"), async (req, res) => {
  try {
    let fileUrl = "";
    if (req.file) {
      fileUrl = await uploadToSupabase(req.file, "surat-masuk");
    }

    const surat = await prisma.suratMasuk.create({
      data: {
        ...req.body,
        fileUrl,
      },
    });

    res.json(surat);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.put("/api/surat-masuk/:id", upload.single("file"), async (req, res) => {
  try {
    const id = parseInt(req.params.id);
    let fileUrl = req.body.fileUrl;

    if (req.file) {
      fileUrl = await uploadToSupabase(req.file, "surat-masuk");
    }

    const surat = await prisma.suratMasuk.update({
      where: { id },
      data: {
        ...req.body,
        fileUrl,
      },
    });

    res.json(surat);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.delete("/api/surat-masuk/:id", async (req, res) => {
  try {
    const id = parseInt(req.params.id);
    await prisma.suratMasuk.delete({ where: { id } });
    res.json({ message: "Surat masuk berhasil dihapus" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// =============== SURAT KELUAR ===============

app.get("/api/surat-keluar", async (req, res) => {
  const result = await prisma.suratKeluar.findMany();
  res.json(result);
});

app.post("/api/surat-keluar", upload.single("file"), async (req, res) => {
  try {
    let fileUrl = "";
    if (req.file) {
      fileUrl = await uploadToSupabase(req.file, "surat-keluar");
    }

    const surat = await prisma.suratKeluar.create({
      data: {
        ...req.body,
        fileUrl,
      },
    });

    res.json(surat);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.put("/api/surat-keluar/:id", upload.single("file"), async (req, res) => {
  try {
    const id = parseInt(req.params.id);
    let fileUrl = req.body.fileUrl;

    if (req.file) {
      fileUrl = await uploadToSupabase(req.file, "surat-keluar");
    }

    const surat = await prisma.suratKeluar.update({
      where: { id },
      data: {
        ...req.body,
        fileUrl,
      },
    });

    res.json(surat);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.delete("/api/surat-keluar/:id", async (req, res) => {
  try {
    const id = parseInt(req.params.id);
    await prisma.suratKeluar.delete({ where: { id } });
    res.json({ message: "Surat keluar berhasil dihapus" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server berjalan di http://localhost:${PORT}`);
});
