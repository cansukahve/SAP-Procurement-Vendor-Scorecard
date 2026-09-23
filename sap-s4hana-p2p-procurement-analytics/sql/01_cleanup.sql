-- ============================================================================
-- 01_cleanup.sql
-- SAP_Procurement - Nova Teknoloji Ltd. Sti. elektronik perakende senaryosu
-- Amac: Eski/test verilerini (Apple, kahve vb.) temizle ve view'lari kaldir
-- Siralamaya dikkat: FK iliskileri nedeniyle silme ters bagimlilik sirasiyla
-- Calistirma: sqlcmd -S "CANSU\SQLEXPRESS02" -d SAP_Procurement -i 01_cleanup.sql
-- ============================================================================
SET NOCOUNT ON;
PRINT N'--- 01_cleanup: Basladi ---';

-- 1) Analitik View'lari kaldir (varsa)
IF OBJECT_ID('dbo.vw_FulfillmentStatus', 'V') IS NOT NULL
BEGIN
    DROP VIEW dbo.vw_FulfillmentStatus;
    PRINT N'  View silindi: vw_FulfillmentStatus';
END
IF OBJECT_ID('dbo.vw_VendorOTDPerformance', 'V') IS NOT NULL
BEGIN
    DROP VIEW dbo.vw_VendorOTDPerformance;
    PRINT N'  View silindi: vw_VendorOTDPerformance';
END
IF OBJECT_ID('dbo.vw_SpendAnalysis', 'V') IS NOT NULL
BEGIN
    DROP VIEW dbo.vw_SpendAnalysis;
    PRINT N'  View silindi: vw_SpendAnalysis';
END
-- Olası eski view isimleri (önceki denemeler)
IF OBJECT_ID('dbo.vw_fulfillment', 'V') IS NOT NULL DROP VIEW dbo.vw_fulfillment;
IF OBJECT_ID('dbo.vw_vendor_otd', 'V') IS NOT NULL DROP VIEW dbo.vw_vendor_otd;
IF OBJECT_ID('dbo.vw_spend', 'V') IS NOT NULL DROP VIEW dbo.vw_spend;

-- 2) FK sirasina gore temizlik: MSEG -> EKPO -> EKKO -> LFA1/MARA
--    TRUNCATE FK nedeniyle calismaz, DELETE kullanilir.

PRINT N'  MSEG temizleniyor...';
DELETE FROM dbo.MSEG;

PRINT N'  EKPO temizleniyor...';
DELETE FROM dbo.EKPO;

PRINT N'  EKKO temizleniyor...';
DELETE FROM dbo.EKKO;

PRINT N'  LFA1 temizleniyor...';
DELETE FROM dbo.LFA1;

PRINT N'  MARA temizleniyor...';
DELETE FROM dbo.MARA;

-- Dogrulama
SELECT 'MARA' AS Tablo, COUNT(*) AS KalanKayit FROM dbo.MARA
UNION ALL SELECT 'LFA1', COUNT(*) FROM dbo.LFA1
UNION ALL SELECT 'EKKO', COUNT(*) FROM dbo.EKKO
UNION ALL SELECT 'EKPO', COUNT(*) FROM dbo.EKPO
UNION ALL SELECT 'MSEG', COUNT(*) FROM dbo.MSEG;

PRINT N'--- 01_cleanup: Tamamlandi (tum tablolar bos) ---';
GO
