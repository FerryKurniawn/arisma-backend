/*
  Warnings:

  - Changed the type of `tanggalKeluar` on the `SuratKeluar` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `tanggalTerima` on the `SuratMasuk` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- AlterTable
ALTER TABLE "SuratKeluar" ADD COLUMN     "fileUrl" TEXT,
DROP COLUMN "tanggalKeluar",
ADD COLUMN     "tanggalKeluar" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "SuratMasuk" ADD COLUMN     "disposisikanKe" TEXT,
ADD COLUMN     "tenggatWaktu" TIMESTAMP(3),
DROP COLUMN "tanggalTerima",
ADD COLUMN     "tanggalTerima" TIMESTAMP(3) NOT NULL;

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

-- AddForeignKey
ALTER TABLE "DaftarDisposisi" ADD CONSTRAINT "DaftarDisposisi_suratMasukId_fkey" FOREIGN KEY ("suratMasukId") REFERENCES "SuratMasuk"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
