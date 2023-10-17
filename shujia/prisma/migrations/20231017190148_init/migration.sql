-- CreateTable
CREATE TABLE "Book" (
    "uuid" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "title" TEXT NOT NULL,

    CONSTRAINT "Book_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "BookRevision" (
    "uuid" UUID NOT NULL,
    "isRaw" BOOLEAN NOT NULL DEFAULT true,
    "bookRawId" UUID,
    "bookEditedId" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "content" TEXT[],
    "raw" TEXT,
    "systemPrompt" TEXT,
    "userPrompt" TEXT,
    "model" TEXT,
    "requestId" TEXT,
    "promptTokens" INTEGER,
    "completionTokens" INTEGER,
    "totalTokens" INTEGER,
    "sceneDescription" TEXT[],

    CONSTRAINT "BookRevision_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "Character" (
    "uuid" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,

    CONSTRAINT "Character_pkey" PRIMARY KEY ("uuid")
);

-- CreateTable
CREATE TABLE "_BookRevisionToCharacter" (
    "A" UUID NOT NULL,
    "B" UUID NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "BookRevision_bookRawId_key" ON "BookRevision"("bookRawId");

-- CreateIndex
CREATE UNIQUE INDEX "BookRevision_bookEditedId_key" ON "BookRevision"("bookEditedId");

-- CreateIndex
CREATE UNIQUE INDEX "_BookRevisionToCharacter_AB_unique" ON "_BookRevisionToCharacter"("A", "B");

-- CreateIndex
CREATE INDEX "_BookRevisionToCharacter_B_index" ON "_BookRevisionToCharacter"("B");

-- AddForeignKey
ALTER TABLE "BookRevision" ADD CONSTRAINT "BookRevision_bookRawId_fkey" FOREIGN KEY ("bookRawId") REFERENCES "Book"("uuid") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BookRevision" ADD CONSTRAINT "BookRevision_bookEditedId_fkey" FOREIGN KEY ("bookEditedId") REFERENCES "Book"("uuid") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BookRevisionToCharacter" ADD CONSTRAINT "_BookRevisionToCharacter_A_fkey" FOREIGN KEY ("A") REFERENCES "BookRevision"("uuid") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BookRevisionToCharacter" ADD CONSTRAINT "_BookRevisionToCharacter_B_fkey" FOREIGN KEY ("B") REFERENCES "Character"("uuid") ON DELETE CASCADE ON UPDATE CASCADE;
