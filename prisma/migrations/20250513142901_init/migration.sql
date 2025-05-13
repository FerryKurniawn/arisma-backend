-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'KEPSEK');

-- CreateEnum
CREATE TYPE "SifatSurat" AS ENUM ('SangatSegera', 'Segera', 'Biasa');

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'ADMIN',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SuratMasuk" (
    "id" SERIAL NOT NULL,
    "noSurat" TEXT NOT NULL,
    "perihal" TEXT NOT NULL,
    "alamatPengirim" TEXT NOT NULL,
    "tanggalTerima" TIMESTAMP(3) NOT NULL,
    "sifatSurat" "SifatSurat" NOT NULL,
    "fileUrl" TEXT,
    "disposisi" TEXT,
    "isiDisposisi" TEXT,
    "disposisikanKe" TEXT,
    "tenggatWaktu" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SuratMasuk_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DaftarDisposisi" (
    "id" SERIAL NOT NULL,
    "suratMasukId" INTEGER NOT NULL,
    "disposisikanKe" TEXT NOT NULL,
    "isiDisposisi" TEXT NOT NULL,
    "tenggatWaktu" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DaftarDisposisi_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SuratKeluar" (
    "id" SERIAL NOT NULL,
    "noSurat" TEXT NOT NULL,
    "noBerkas" TEXT NOT NULL,
    "alamatPenerima" TEXT NOT NULL,
    "tanggalKeluar" TIMESTAMP(3) NOT NULL,
    "perihal" TEXT NOT NULL,
    "noPetunjuk" TEXT NOT NULL,
    "noPaket" TEXT NOT NULL,
    "fileUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SuratKeluar_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- AddForeignKey
ALTER TABLE "DaftarDisposisi" ADD CONSTRAINT "DaftarDisposisi_suratMasukId_fkey" FOREIGN KEY ("suratMasukId") REFERENCES "SuratMasuk"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
