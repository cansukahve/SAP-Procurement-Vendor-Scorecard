-- ============================================================================
-- 00_master_build.sql
-- SAP_Procurement - Nova Teknoloji Ltd. Sti. Tek Tikla Kurulum
-- Tum modulleri sirasiyla calistirir
-- Kullanim:
--   sqlcmd -S "CANSU\SQLEXPRESS02" -d SAP_Procurement -i 00_master_build.sql
-- Not: Bu dosya sql/ klasoru icinden calistirilmali (relative path :r)
-- ============================================================================
SET NOCOUNT ON;
PRINT N'================================================================';
PRINT N' Nova Teknoloji - SAP_Procurement Build Basladi';
PRINT N' Instance: CANSU\SQLEXPRESS02 | DB: SAP_Procurement';
PRINT N'================================================================';

:r 01_cleanup.sql
:r 02_seed_MARA.sql
:r 03_seed_LFA1.sql
:r 04_seed_EKKO.sql
:r 05_seed_EKPO.sql
:r 06_seed_MSEG.sql
:r 07_create_views.sql
:r 08_verify.sql

PRINT N'================================================================';
PRINT N' Build Tamamlandi - Tum tablolar ve viewlar hazir!';
PRINT N' Power BI icin: sqlcmd ile viewlari sorgulayin veya SSMS''ten baglanin';
PRINT N'================================================================';
GO
