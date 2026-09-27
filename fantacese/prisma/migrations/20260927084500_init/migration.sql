-- CreateEnum
CREATE TYPE "SiteRole" AS ENUM ('USER', 'SITE_ADMIN');

-- CreateEnum
CREATE TYPE "LeagueRole" AS ENUM ('MEMBER', 'LEAGUE_ADMIN');

-- CreateEnum
CREATE TYPE "TeamGender" AS ENUM ('MIXED', 'FEMALE');

-- CreateEnum
CREATE TYPE "AuctionType" AS ENUM ('BLIND', 'RAISE', 'LIVE');

-- CreateEnum
CREATE TYPE "AuctionCategory" AS ENUM ('INDIVIDUALISTS', 'TEAMS_MIXED', 'TEAMS_FEMALE');

-- CreateEnum
CREATE TYPE "AuctionStatus" AS ENUM ('DRAFT', 'OPEN', 'CLOSED');

-- CreateEnum
CREATE TYPE "LotStatus" AS ENUM ('PENDING', 'OPEN', 'CLOSED');

-- CreateEnum
CREATE TYPE "TradeStatus" AS ENUM ('PENDING', 'ACCEPTED', 'REJECTED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "TradeDirection" AS ENUM ('FROM_GIVES', 'TO_GIVES');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "displayName" TEXT NOT NULL,
    "siteRole" "SiteRole" NOT NULL DEFAULT 'USER',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "League" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "isPublic" BOOLEAN NOT NULL DEFAULT true,
    "ownerId" TEXT NOT NULL,
    "settings" JSONB NOT NULL DEFAULT '{}',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "League_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LeagueMembership" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "leagueId" TEXT NOT NULL,
    "role" "LeagueRole" NOT NULL DEFAULT 'MEMBER',
    "joinedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LeagueMembership_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LeaguePost" (
    "id" TEXT NOT NULL,
    "leagueId" TEXT NOT NULL,
    "authorId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "body" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LeaguePost_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Individualist" (
    "id" TEXT NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "district" TEXT NOT NULL,
    "valuation" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Individualist_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MathTeam" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "valuation" DOUBLE PRECISION NOT NULL,
    "localRace" TEXT NOT NULL,
    "gender" "TeamGender" NOT NULL DEFAULT 'MIXED',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MathTeam_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FantaTeam" (
    "id" TEXT NOT NULL,
    "leagueId" TEXT NOT NULL,
    "ownerId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "credits" DOUBLE PRECISION NOT NULL,
    "captainId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "FantaTeam_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RosterEntry" (
    "id" TEXT NOT NULL,
    "fantaTeamId" TEXT NOT NULL,
    "individualistId" TEXT,
    "mathTeamId" TEXT,
    "pricePaid" DOUBLE PRECISION NOT NULL,
    "isCaptain" BOOLEAN NOT NULL DEFAULT false,
    "isConsegnatore" BOOLEAN NOT NULL DEFAULT false,
    "acquiredAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RosterEntry_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Auction" (
    "id" TEXT NOT NULL,
    "leagueId" TEXT NOT NULL,
    "type" "AuctionType" NOT NULL,
    "category" "AuctionCategory" NOT NULL,
    "status" "AuctionStatus" NOT NULL DEFAULT 'DRAFT',
    "createdById" TEXT NOT NULL,
    "settings" JSONB NOT NULL DEFAULT '{}',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Auction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuctionLot" (
    "id" TEXT NOT NULL,
    "auctionId" TEXT NOT NULL,
    "individualistId" TEXT,
    "mathTeamId" TEXT,
    "status" "LotStatus" NOT NULL DEFAULT 'PENDING',
    "openedAt" TIMESTAMP(3),
    "closingAt" TIMESTAMP(3),
    "currentAmount" DOUBLE PRECISION,
    "winnerTeamId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AuctionLot_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Bid" (
    "id" TEXT NOT NULL,
    "auctionLotId" TEXT NOT NULL,
    "fantaTeamId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Bid_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Trade" (
    "id" TEXT NOT NULL,
    "leagueId" TEXT NOT NULL,
    "fromTeamId" TEXT NOT NULL,
    "toTeamId" TEXT NOT NULL,
    "status" "TradeStatus" NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "respondedAt" TIMESTAMP(3),

    CONSTRAINT "Trade_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TradeItem" (
    "id" TEXT NOT NULL,
    "tradeId" TEXT NOT NULL,
    "direction" "TradeDirection" NOT NULL,
    "individualistId" TEXT,
    "mathTeamId" TEXT,
    "credits" DOUBLE PRECISION,

    CONSTRAINT "TradeItem_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "LeagueMembership_userId_leagueId_key" ON "LeagueMembership"("userId", "leagueId");

-- CreateIndex
CREATE UNIQUE INDEX "Individualist_firstName_lastName_district_key" ON "Individualist"("firstName", "lastName", "district");

-- CreateIndex
CREATE UNIQUE INDEX "MathTeam_name_key" ON "MathTeam"("name");

-- CreateIndex
CREATE UNIQUE INDEX "FantaTeam_leagueId_ownerId_key" ON "FantaTeam"("leagueId", "ownerId");

-- AddForeignKey
ALTER TABLE "League" ADD CONSTRAINT "League_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LeagueMembership" ADD CONSTRAINT "LeagueMembership_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LeagueMembership" ADD CONSTRAINT "LeagueMembership_leagueId_fkey" FOREIGN KEY ("leagueId") REFERENCES "League"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LeaguePost" ADD CONSTRAINT "LeaguePost_leagueId_fkey" FOREIGN KEY ("leagueId") REFERENCES "League"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FantaTeam" ADD CONSTRAINT "FantaTeam_leagueId_fkey" FOREIGN KEY ("leagueId") REFERENCES "League"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FantaTeam" ADD CONSTRAINT "FantaTeam_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RosterEntry" ADD CONSTRAINT "RosterEntry_fantaTeamId_fkey" FOREIGN KEY ("fantaTeamId") REFERENCES "FantaTeam"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RosterEntry" ADD CONSTRAINT "RosterEntry_individualistId_fkey" FOREIGN KEY ("individualistId") REFERENCES "Individualist"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RosterEntry" ADD CONSTRAINT "RosterEntry_mathTeamId_fkey" FOREIGN KEY ("mathTeamId") REFERENCES "MathTeam"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Auction" ADD CONSTRAINT "Auction_leagueId_fkey" FOREIGN KEY ("leagueId") REFERENCES "League"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Auction" ADD CONSTRAINT "Auction_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuctionLot" ADD CONSTRAINT "AuctionLot_auctionId_fkey" FOREIGN KEY ("auctionId") REFERENCES "Auction"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuctionLot" ADD CONSTRAINT "AuctionLot_individualistId_fkey" FOREIGN KEY ("individualistId") REFERENCES "Individualist"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuctionLot" ADD CONSTRAINT "AuctionLot_mathTeamId_fkey" FOREIGN KEY ("mathTeamId") REFERENCES "MathTeam"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuctionLot" ADD CONSTRAINT "AuctionLot_winnerTeamId_fkey" FOREIGN KEY ("winnerTeamId") REFERENCES "FantaTeam"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bid" ADD CONSTRAINT "Bid_auctionLotId_fkey" FOREIGN KEY ("auctionLotId") REFERENCES "AuctionLot"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bid" ADD CONSTRAINT "Bid_fantaTeamId_fkey" FOREIGN KEY ("fantaTeamId") REFERENCES "FantaTeam"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bid" ADD CONSTRAINT "Bid_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Trade" ADD CONSTRAINT "Trade_leagueId_fkey" FOREIGN KEY ("leagueId") REFERENCES "League"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Trade" ADD CONSTRAINT "Trade_fromTeamId_fkey" FOREIGN KEY ("fromTeamId") REFERENCES "FantaTeam"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Trade" ADD CONSTRAINT "Trade_toTeamId_fkey" FOREIGN KEY ("toTeamId") REFERENCES "FantaTeam"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TradeItem" ADD CONSTRAINT "TradeItem_tradeId_fkey" FOREIGN KEY ("tradeId") REFERENCES "Trade"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TradeItem" ADD CONSTRAINT "TradeItem_individualistId_fkey" FOREIGN KEY ("individualistId") REFERENCES "Individualist"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TradeItem" ADD CONSTRAINT "TradeItem_mathTeamId_fkey" FOREIGN KEY ("mathTeamId") REFERENCES "MathTeam"("id") ON DELETE SET NULL ON UPDATE CASCADE;
