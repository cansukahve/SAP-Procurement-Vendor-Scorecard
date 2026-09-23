-- ============================================================================
-- 07_create_views.sql
-- Analitik Katman - 3 View (Turkce kolon aliaslari)
--   vw_FulfillmentStatus      : Siparis edilen/gelen/acik miktarlar
--   vw_VendorOTDPerformance   : DATEDIFF ile gecikme ve Zamaninda/Gecikmeli/Acik
--   vw_SpendAnalysis          : Tedarikci bazinda toplam harcama ve siparis adetleri
-- ============================================================================
SET NOCOUNT ON;
PRINT N'--- 07_create_views: Basladi ---';

-- Eski view'lari temizle (idempotent)
IF OBJECT_ID('dbo.vw_FulfillmentStatus', 'V') IS NOT NULL DROP VIEW dbo.vw_FulfillmentStatus;
IF OBJECT_ID('dbo.vw_VendorOTDPerformance', 'V') IS NOT NULL DROP VIEW dbo.vw_VendorOTDPerformance;
IF OBJECT_ID('dbo.vw_SpendAnalysis', 'V') IS NOT NULL DROP VIEW dbo.vw_SpendAnalysis;
GO

-- ============================================================================
-- 1) vw_FulfillmentStatus
-- Her EKPO kalemi icin: siparis edilen, gelen (MSEG toplami), acik kalan
-- TeslimatDurumu: Tam / Kismi / Acik
-- ============================================================================
CREATE VIEW dbo.vw_FulfillmentStatus AS
SELECT
    k.ebeln                                           AS SiparisNo,
    k.lifnr                                           AS TedarikciNo,
    s.name1                                           AS TedarikciAdi,
    s.land1                                           AS Ulke,
    s.ort01                                           AS Sehir,
    p.ebelp                                           AS KalemNo,
    p.matnr                                           AS MalzemeNo,
    m.maktx                                           AS MalzemeAciklamasi,
    m.mtart                                           AS UrunTipi,
    m.meins                                           AS Birim,
    k.bedat                                           AS SiparisTarihi,
    p.eindt                                           AS TaahhutTarihi,
    p.menge                                           AS SiparisMiktari,
    p.netpr                                           AS BirimFiyat,
    p.menge * p.netpr                                 AS SiparisTutari,
    COALESCE(SUM(g.menge), 0)                         AS GelenMiktar,
    p.menge - COALESCE(SUM(g.menge), 0)               AS AcikMiktar,
    CASE 
        WHEN COALESCE(SUM(g.menge), 0) = 0 THEN N'Açık'
        WHEN COALESCE(SUM(g.menge), 0) <  p.menge THEN N'Kısmi'
        ELSE N'Tam'
    END                                               AS TeslimatDurumu,
    MAX(g.budat)                                      AS SonTeslimTarihi,
    -- Karsilanma orani % (Power BI icin)
    CASE WHEN p.menge = 0 THEN 0 
         ELSE CAST(COALESCE(SUM(g.menge),0) * 100.0 / p.menge AS DECIMAL(5,2)) END AS KarsilanmaOraniYuzde
FROM dbo.EKKO k
JOIN dbo.EKPO p  ON k.ebeln = p.ebeln
JOIN dbo.MARA m  ON p.matnr = m.matnr
JOIN dbo.LFA1 s  ON k.lifnr = s.lifnr
LEFT JOIN dbo.MSEG g ON p.ebeln = g.ebeln AND p.ebelp = g.ebelp AND g.bwart = '101'
GROUP BY k.ebeln, k.lifnr, s.name1, s.land1, s.ort01, p.ebelp, p.matnr, m.maktx, m.mtart, m.meins, k.bedat, p.eindt, p.menge, p.netpr;
GO
PRINT N'  View olusturuldu: vw_FulfillmentStatus';
GO

-- ============================================================================
-- 2) vw_VendorOTDPerformance
-- Her mal kabul (MSEG) icin gecikme gunu ve durum
-- Acik kalemler icin de satir uretir (MSEG yoksa GecikmeGunu NULL, TeslimatDurumu='Açık')
-- Kalem bazli detay view'dir; tedarikci ozeti icin GROUP BY ile kullanilir
-- ============================================================================
CREATE VIEW dbo.vw_VendorOTDPerformance AS
SELECT
    k.ebeln                                           AS SiparisNo,
    p.ebelp                                           AS KalemNo,
    p.matnr                                           AS MalzemeNo,
    m.maktx                                           AS MalzemeAciklamasi,
    k.lifnr                                           AS TedarikciNo,
    s.name1                                           AS TedarikciAdi,
    s.land1                                           AS Ulke,
    s.ort01                                           AS Sehir,
    k.bedat                                           AS SiparisTarihi,
    p.eindt                                           AS TaahhutTarihi,
    g.budat                                           AS FiiliTeslimTarihi,
    g.bldat                                           AS BelgeTarihi,
    g.mblnr                                           AS MalGirisNo,
    g.mjahr                                           AS MalGirisYili,
    g.zeile                                           AS MalGirisSatiri,
    p.menge                                           AS SiparisMiktari,
    g.menge                                           AS GelenMiktar,
    DATEDIFF(DAY, p.eindt, g.budat)                   AS GecikmeGunu,
    CASE 
        WHEN g.budat IS NULL THEN N'Açık'
        WHEN g.budat <= p.eindt THEN N'Zamanında'
        ELSE N'Gecikmeli'
    END                                               AS TeslimatDurumu,
    p.netpr                                           AS BirimFiyat
FROM dbo.EKPO p
JOIN dbo.EKKO k ON p.ebeln = k.ebeln
JOIN dbo.LFA1 s ON k.lifnr = s.lifnr
JOIN dbo.MARA m ON p.matnr = m.matnr
LEFT JOIN dbo.MSEG g ON p.ebeln = g.ebeln AND p.ebelp = g.ebelp AND g.bwart = '101';
GO
PRINT N'  View olusturuldu: vw_VendorOTDPerformance';
GO

-- ============================================================================
-- 3) vw_SpendAnalysis
-- Tedarikci bazinda harcama analizi: toplam siparis degeri, gelen deger, siparis adetleri
-- ============================================================================
CREATE VIEW dbo.vw_SpendAnalysis AS
SELECT
    k.lifnr                                           AS TedarikciNo,
    s.name1                                           AS TedarikciAdi,
    s.land1                                           AS Ulke,
    s.ort01                                           AS Sehir,
    COUNT(DISTINCT k.ebeln)                           AS SiparisSayisi,
    COUNT(*)                                          AS KalemSayisi,
    SUM(p.menge * p.netpr)                            AS ToplamSiparisTutari,
    SUM(COALESCE(g.ToplamGelen, 0) * p.netpr)         AS ToplamGelenTutari,
    SUM(p.menge * p.netpr) - SUM(COALESCE(g.ToplamGelen, 0) * p.netpr) AS AcikTutar,
    AVG(p.netpr)                                      AS OrtalamaBirimFiyat,
    SUM(p.menge)                                      AS ToplamSiparisMiktari,
    SUM(COALESCE(g.ToplamGelen, 0))                   AS ToplamGelenMiktar
FROM dbo.EKKO k
JOIN dbo.LFA1 s ON k.lifnr = s.lifnr
JOIN dbo.EKPO p ON k.ebeln = p.ebeln
LEFT JOIN (
    SELECT ebeln, ebelp, SUM(menge) AS ToplamGelen
    FROM dbo.MSEG WHERE bwart = '101'
    GROUP BY ebeln, ebelp
) g ON p.ebeln = g.ebeln AND p.ebelp = g.ebelp
GROUP BY k.lifnr, s.name1, s.land1, s.ort01;
GO
PRINT N'  View olusturuldu: vw_SpendAnalysis';
GO

-- Dogrulama
SELECT 'vw_FulfillmentStatus' AS ViewAdi, COUNT(*) AS SatirSayisi FROM dbo.vw_FulfillmentStatus
UNION ALL SELECT 'vw_VendorOTDPerformance', COUNT(*) FROM dbo.vw_VendorOTDPerformance
UNION ALL SELECT 'vw_SpendAnalysis', COUNT(*) FROM dbo.vw_SpendAnalysis;

PRINT N'--- 07_create_views: Tamamlandi (3 view) ---';
GO
