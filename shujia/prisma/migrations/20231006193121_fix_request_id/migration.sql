/*
  Warnings:

  - You are about to drop the column `requestID` on the `BookRevision` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "BookRevision" DROP COLUMN "requestID",
ADD COLUMN     "requestId" TEXT;
