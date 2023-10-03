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

    CONSTRAINT "BookRevision_pkey" PRIMARY KEY ("uuid")
);

-- CreateIndex
CREATE UNIQUE INDEX "BookRevision_bookRawId_key" ON "BookRevision"("bookRawId");

-- CreateIndex
CREATE UNIQUE INDEX "BookRevision_bookEditedId_key" ON "BookRevision"("bookEditedId");

-- AddForeignKey
ALTER TABLE "BookRevision" ADD CONSTRAINT "BookRevision_bookRawId_fkey" FOREIGN KEY ("bookRawId") REFERENCES "Book"("uuid") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BookRevision" ADD CONSTRAINT "BookRevision_bookEditedId_fkey" FOREIGN KEY ("bookEditedId") REFERENCES "Book"("uuid") ON DELETE SET NULL ON UPDATE CASCADE;
