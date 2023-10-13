/*
  Warnings:

  - You are about to drop the `_BookToCharacter` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "_BookToCharacter" DROP CONSTRAINT "_BookToCharacter_A_fkey";

-- DropForeignKey
ALTER TABLE "_BookToCharacter" DROP CONSTRAINT "_BookToCharacter_B_fkey";

-- AlterTable
ALTER TABLE "BookRevision" ADD COLUMN     "sceneDescription" TEXT[];

-- DropTable
DROP TABLE "_BookToCharacter";

-- CreateTable
CREATE TABLE "_BookRevisionToCharacter" (
    "A" UUID NOT NULL,
    "B" UUID NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_BookRevisionToCharacter_AB_unique" ON "_BookRevisionToCharacter"("A", "B");

-- CreateIndex
CREATE INDEX "_BookRevisionToCharacter_B_index" ON "_BookRevisionToCharacter"("B");

-- AddForeignKey
ALTER TABLE "_BookRevisionToCharacter" ADD CONSTRAINT "_BookRevisionToCharacter_A_fkey" FOREIGN KEY ("A") REFERENCES "BookRevision"("uuid") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BookRevisionToCharacter" ADD CONSTRAINT "_BookRevisionToCharacter_B_fkey" FOREIGN KEY ("B") REFERENCES "Character"("uuid") ON DELETE CASCADE ON UPDATE CASCADE;
