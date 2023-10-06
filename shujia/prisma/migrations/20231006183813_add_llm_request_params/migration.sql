-- AlterTable
ALTER TABLE "BookRevision" ADD COLUMN     "completionTokens" INTEGER,
ADD COLUMN     "model" TEXT,
ADD COLUMN     "promptTokens" INTEGER,
ADD COLUMN     "requestID" TEXT,
ADD COLUMN     "systemPrompt" TEXT,
ADD COLUMN     "totalTokens" INTEGER,
ADD COLUMN     "userPrompt" TEXT,
ALTER COLUMN "raw" DROP NOT NULL,
ALTER COLUMN "raw" DROP DEFAULT;
