-- CreateEnum
CREATE TYPE "public"."UserRole" AS ENUM ('ADMIN', 'USER');

-- CreateEnum
CREATE TYPE "public"."ReservationStatus" AS ENUM ('PENDING', 'AWAITING_PAYMENT', 'PAID', 'CANCELLED', 'EXPIRED', 'REFUNDED');

-- CreateEnum
CREATE TYPE "public"."HallFormat" AS ENUM ('TWOD', 'THREED', 'IMAX');

-- CreateEnum
CREATE TYPE "public"."AudioLang" AS ENUM ('ORIGINAL', 'RU', 'KZ', 'EN');

-- CreateEnum
CREATE TYPE "public"."Subtitles" AS ENUM ('NONE', 'RU', 'KZ', 'EN');

-- CreateTable
CREATE TABLE "public"."City" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "timezone" TEXT NOT NULL DEFAULT 'Asia/Almaty',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "City_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Cinema" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "address" TEXT,
    "cityId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Cinema_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."CinemaHall" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "format" "public"."HallFormat" NOT NULL DEFAULT 'TWOD',
    "cinemaId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CinemaHall_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Seat" (
    "id" UUID NOT NULL,
    "hallId" UUID NOT NULL,
    "rowLabel" TEXT NOT NULL,
    "seatNumber" INTEGER NOT NULL,
    "seatType" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Seat_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Movie" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "durationMin" INTEGER,
    "rating" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Movie_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."MovieCinema" (
    "id" UUID NOT NULL,
    "cinemaId" UUID NOT NULL,
    "movieId" UUID NOT NULL,
    "basePrice" DECIMAL(10,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'KZT',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MovieCinema_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."MovieCinemaSession" (
    "id" UUID NOT NULL,
    "movieCinemaId" UUID NOT NULL,
    "cinemaHallId" UUID NOT NULL,
    "startsAt" TIMESTAMP(3) NOT NULL,
    "audio" "public"."AudioLang" NOT NULL DEFAULT 'RU',
    "subtitles" "public"."Subtitles" NOT NULL DEFAULT 'NONE',
    "format" "public"."HallFormat" NOT NULL,
    "price" DECIMAL(10,2),
    "currency" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MovieCinemaSession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Reservation" (
    "id" UUID NOT NULL,
    "userId" UUID,
    "status" "public"."ReservationStatus" NOT NULL DEFAULT 'PENDING',
    "expiresAt" TIMESTAMP(3),
    "paidAt" TIMESTAMP(3),
    "total" DECIMAL(10,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'KZT',
    "paymentId" TEXT,
    "meta" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Reservation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ReservationItem" (
    "id" UUID NOT NULL,
    "reservationId" UUID NOT NULL,
    "sessionId" UUID NOT NULL,
    "seatId" UUID NOT NULL,
    "price" DECIMAL(10,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'KZT',

    CONSTRAINT "ReservationItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."User" (
    "id" UUID NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "role" "public"."UserRole" NOT NULL DEFAULT 'USER',
    "phone" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "City_name_key" ON "public"."City"("name");

-- CreateIndex
CREATE INDEX "Cinema_cityId_idx" ON "public"."Cinema"("cityId");

-- CreateIndex
CREATE INDEX "CinemaHall_cinemaId_idx" ON "public"."CinemaHall"("cinemaId");

-- CreateIndex
CREATE INDEX "Seat_hallId_idx" ON "public"."Seat"("hallId");

-- CreateIndex
CREATE UNIQUE INDEX "Seat_hallId_rowLabel_seatNumber_key" ON "public"."Seat"("hallId", "rowLabel", "seatNumber");

-- CreateIndex
CREATE INDEX "MovieCinema_cinemaId_idx" ON "public"."MovieCinema"("cinemaId");

-- CreateIndex
CREATE INDEX "MovieCinema_movieId_idx" ON "public"."MovieCinema"("movieId");

-- CreateIndex
CREATE UNIQUE INDEX "MovieCinema_cinemaId_movieId_key" ON "public"."MovieCinema"("cinemaId", "movieId");

-- CreateIndex
CREATE INDEX "MovieCinemaSession_cinemaHallId_startsAt_idx" ON "public"."MovieCinemaSession"("cinemaHallId", "startsAt");

-- CreateIndex
CREATE INDEX "MovieCinemaSession_movieCinemaId_startsAt_idx" ON "public"."MovieCinemaSession"("movieCinemaId", "startsAt");

-- CreateIndex
CREATE UNIQUE INDEX "MovieCinemaSession_movieCinemaId_cinemaHallId_startsAt_key" ON "public"."MovieCinemaSession"("movieCinemaId", "cinemaHallId", "startsAt");

-- CreateIndex
CREATE INDEX "Reservation_userId_idx" ON "public"."Reservation"("userId");

-- CreateIndex
CREATE INDEX "Reservation_status_idx" ON "public"."Reservation"("status");

-- CreateIndex
CREATE INDEX "Reservation_expiresAt_idx" ON "public"."Reservation"("expiresAt");

-- CreateIndex
CREATE INDEX "ReservationItem_reservationId_idx" ON "public"."ReservationItem"("reservationId");

-- CreateIndex
CREATE INDEX "ReservationItem_sessionId_idx" ON "public"."ReservationItem"("sessionId");

-- CreateIndex
CREATE UNIQUE INDEX "ReservationItem_sessionId_seatId_key" ON "public"."ReservationItem"("sessionId", "seatId");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "public"."User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_phone_key" ON "public"."User"("phone");

-- AddForeignKey
ALTER TABLE "public"."Cinema" ADD CONSTRAINT "Cinema_cityId_fkey" FOREIGN KEY ("cityId") REFERENCES "public"."City"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."CinemaHall" ADD CONSTRAINT "CinemaHall_cinemaId_fkey" FOREIGN KEY ("cinemaId") REFERENCES "public"."Cinema"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Seat" ADD CONSTRAINT "Seat_hallId_fkey" FOREIGN KEY ("hallId") REFERENCES "public"."CinemaHall"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."MovieCinema" ADD CONSTRAINT "MovieCinema_cinemaId_fkey" FOREIGN KEY ("cinemaId") REFERENCES "public"."Cinema"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."MovieCinema" ADD CONSTRAINT "MovieCinema_movieId_fkey" FOREIGN KEY ("movieId") REFERENCES "public"."Movie"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."MovieCinemaSession" ADD CONSTRAINT "MovieCinemaSession_movieCinemaId_fkey" FOREIGN KEY ("movieCinemaId") REFERENCES "public"."MovieCinema"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."MovieCinemaSession" ADD CONSTRAINT "MovieCinemaSession_cinemaHallId_fkey" FOREIGN KEY ("cinemaHallId") REFERENCES "public"."CinemaHall"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Reservation" ADD CONSTRAINT "Reservation_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ReservationItem" ADD CONSTRAINT "ReservationItem_reservationId_fkey" FOREIGN KEY ("reservationId") REFERENCES "public"."Reservation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ReservationItem" ADD CONSTRAINT "ReservationItem_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "public"."MovieCinemaSession"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ReservationItem" ADD CONSTRAINT "ReservationItem_seatId_fkey" FOREIGN KEY ("seatId") REFERENCES "public"."Seat"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
