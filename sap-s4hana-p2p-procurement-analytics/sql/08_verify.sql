-- ============================================================================
-- 08_verify.sql
-- Dogrulama & Power BI Hazir Sorgular
-- Calistirma: sqlcmd -S "CANSU\SQLEXPRESS02" -d SAP_Procurement -i 08_verify.sql
-- ============================================================================
SET NOCOUNT ON;
PRINT N'========== DOGRULAMA BASLADI ==========';

-- 1) Sayimlar
PRINT N'--- Tablo Sayimlari ---';
SELECT 'MARA' AS Tablo, COUNT(*) AS KayitSayisi, 'En az 15 (HAWA+ROH)' AS Beklenti FROM dbo.MARA
UNION ALL SELECT 'LFA1', COUNT(*), 'En az 6' FROM dbo.LFA1
UNION ALL SELECT 'EKKO', COUNT(*), 'En az 10-12' FROM dbo.EKKO
UNION ALL SELECT 'EKPO', COUNT(*), 'En az 25-30' FROM dbo.EKPO
UNION ALL SELECT 'MSEG (satir)', COUNT(*), 'En az 20-25' FROM dbo.MSEG
UNION ALL SELECT 'MSEG (kapsanan kalem)', COUNT(DISTINCT CONCAT(ebeln,'-',ebelp)), '18-19 kalem' FROM dbo.MSEG;

PRINT N'--- Urun Tipi Dagilimi (MARA) ---';
SELECT mtart AS UrunTipi, COUNT(*) AS Adet FROM dbo.MARA GROUP BY mtart;

PRINT N'--- 4 Senaryo Dagilimi (vw_FulfillmentStatus uzerinden) ---';
SELECT TeslimatDurumu, COUNT(*) AS KalemSayisi FROM dbo.vw_FulfillmentStatus GROUP BY TeslimatDurumu
UNION ALL
SELECT 'Toplam', COUNT(*) FROM dbo.vw_FulfillmentStatus;

PRINT N'--- Gecikme Dagilimi (vw_VendorOTDPerformance - distinct kalem bazli) ---';
-- distinct kalem icin son teslim tarihi baz al
WITH SonTeslim AS (
  SELECT SiparisNo, KalemNo, MAX(FiiliTeslimTarihi) AS FiiliTeslimTarihi, MAX(TaahhutTarihi) AS TaahhutTarihi,
         MAX(CASE WHEN FiiliTeslimTarihi IS NULL THEN 1 ELSE 0 END) AS AcikMi
  FROM dbo.vw_VendorOTDPerformance
  GROUP BY SiparisNo, KalemNo
)
SELECT 
  CASE WHEN AcikMi=1 THEN N'Açık'
       WHEN FiiliTeslimTarihi <= TaahhutTarihi THEN N'Zamanında'
       ELSE N'Gecikmeli' END AS TeslimatDurumu,
  COUNT(*) AS KalemSayisi
FROM SonTeslim GROUP BY CASE WHEN AcikMi=1 THEN N'Açık' WHEN FiiliTeslimTarihi <= TaahhutTarihi THEN N'Zamanında' ELSE N'Gecikmeli' END;

PRINT N'--- Tedarikci Bazinda Siparis Ozeti (vw_SpendAnalysis) ---';
SELECT * FROM dbo.vw_SpendAnalysis ORDER BY ToplamSiparisTutari DESC;

PRINT N'========== POWER BI HAZIR SORGULAR ==========';

PRINT N'-- 1) Fulfillment Status tumu (Power BI ana tablo) --';
-- SELECT * FROM dbo.vw_FulfillmentStatus ORDER BY SiparisNo, KalemNo;

PRINT N'-- 2) Vendor OTD detay --';
-- SELECT * FROM dbo.vw_VendorOTDPerformance ORDER BY TedarikciAdi, SiparisNo;

PRINT N'-- 3) Spend Analysis --';
-- SELECT * FROM dbo.vw_SpendAnalysis ORDER BY ToplamSiparisTutari DESC;

-- Power BI icin ek hazir sorgular (yorumdan cikarip calistirin)
PRINT N'--- Power BI: Tedarikci OTD Orani (DK gecikme %) ---';
SELECT 
  TedarikciAdi,
  COUNT(*) AS ToplamKalem,
  SUM(CASE WHEN TeslimatDurumu = N'Zamanında' THEN 1 ELSE 0 END) AS ZamanindaKalem,
  SUM(CASE WHEN TeslimatDurumu = N'Gecikmeli' THEN 1 ELSE 0 END) AS GecikmeliKalem,
  SUM(CASE WHEN TeslimatDurumu = N'Açık' THEN 1 ELSE 0 END) AS AcikKalem,
  CAST(SUM(CASE WHEN TeslimatDurumu = N'Zamanında' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS OTD_Yuzde
FROM (
  SELECT SiparisNo, KalemNo, TedarikciAdi,
    CASE WHEN MAX(FiiliTeslimTarihi) IS NULL THEN N'Açık'
         WHEN MAX(FiiliTeslimTarihi) <= MAX(TaahhutTarihi) THEN N'Zamanında'
         ELSE N'Gecikmeli' END AS TeslimatDurumu
  FROM dbo.vw_VendorOTDPerformance
  GROUP BY SiparisNo, KalemNo, TedarikciAdi
) t GROUP BY TedarikciAdi ORDER BY OTD_Yuzde DESC;

PRINT N'--- Power BI: Aylik Siparis Trendi ---';
SELECT FORMAT(SiparisTarihi, 'yyyy-MM') AS Ay, COUNT(DISTINCT SiparisNo) AS SiparisSayisi, SUM(SiparisTutari) AS ToplamTutar
FROM dbo.vw_FulfillmentStatus GROUP BY FORMAT(SiparisTarihi, 'yyyy-MM') ORDER BY Ay;

PRINT N'--- Power BI: Urun Bazinda Harcama ---';
SELECT MalzemeNo, MalzemeAciklamasi, UrunTipi, SUM(SiparisMiktari) AS ToplamMiktar, SUM(SiparisTutari) AS ToplamTutar
FROM dbo.vw_FulfillmentStatus GROUP BY MalzemeNo, MalzemeAciklamasi, UrunTipi ORDER BY ToplamTutar DESC;

PRINT N'--- Power BI: Acik Siparisler (yolda) ---';
SELECT SiparisNo, TedarikciAdi, KalemNo, MalzemeAciklamasi, SiparisMiktari, AcikMiktar, TaahhutTarihi, SiparisTarihi
FROM dbo.vw_FulfillmentStatus WHERE TeslimatDurumu = N'Açık' ORDER BY TaahhutTarihi;

PRINT N'--- Power BI: Gecikmeli Teslimler Detay (GecikmeGunu > 0) ---';
SELECT SiparisNo, KalemNo, TedarikciAdi, TaahhutTarihi, FiiliTeslimTarihi, GecikmeGunu, SiparisMiktari, GelenMiktar
FROM dbo.vw_VendorOTDPerformance WHERE GecikmeGunu > 0 ORDER BY GecikmeGunu DESC;

PRINT N'========== DOGRULAMA TAMAMLANDI ==========';
GO
