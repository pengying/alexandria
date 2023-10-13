-- CreateTable
CREATE TABLE "Character" (
    "uuid" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,

    CONSTRAINT "Character_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "_BookToCharacter" (
    "A" UUID NOT NULL,
    "B" UUID NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_BookToCharacter_AB_unique" ON "_BookToCharacter"("A", "B");

-- CreateIndex
CREATE INDEX "_BookToCharacter_B_index" ON "_BookToCharacter"("B");

-- AddForeignKey
ALTER TABLE "_BookToCharacter" ADD CONSTRAINT "_BookToCharacter_A_fkey" FOREIGN KEY ("A") REFERENCES "Book"("uuid") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BookToCharacter" ADD CONSTRAINT "_BookToCharacter_B_fkey" FOREIGN KEY ("B") REFERENCES "Character"("uuid") ON DELETE CASCADE ON UPDATE CASCADE;
