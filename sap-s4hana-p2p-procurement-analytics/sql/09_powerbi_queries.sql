-- ============================================================================
-- 09_powerbi_queries.sql
-- Power BI / Analitik icin hazir SELECT sorgulari (Turkce kolonlar)
-- Baglanti: Power BI Desktop > SQL Server > CANSU\SQLEXPRESS02 > SAP_Procurement
-- Tum sorgular dogrudan view'lari kullanir, ek JOIN gerekmez
-- ============================================================================

-- 1) Ana Dashboard Tablosu - Fulfillment (her satir bir EKPO kalemi)
SELECT SiparisNo, TedarikciAdi, Ulke, Sehir, KalemNo, MalzemeNo, MalzemeAciklamasi, UrunTipi,
       SiparisTarihi, TaahhutTarihi, SiparisMiktari, BirimFiyat, SiparisTutari,
       GelenMiktar, AcikMiktar, TeslimatDurumu, SonTeslimTarihi, KarsilanmaOraniYuzde
FROM dbo.vw_FulfillmentStatus
ORDER BY SiparisNo, KalemNo;

-- 2) Tedarikci OTD Detay (her mal kabul satiri)
SELECT SiparisNo, KalemNo, TedarikciAdi, Ulke, MalzemeAciklamasi,
       SiparisTarihi, TaahhutTarihi, FiiliTeslimTarihi, GecikmeGunu, TeslimatDurumu,
       SiparisMiktari, GelenMiktar, BirimFiyat
FROM dbo.vw_VendorOTDPerformance
ORDER BY TedarikciAdi, SiparisNo;

-- 3) Harcama Analizi (tedarikci ozet)
SELECT TedarikciNo, TedarikciAdi, Ulke, Sehir,
       SiparisSayisi, KalemSayisi, ToplamSiparisTutari, ToplamGelenTutari, AcikTutar,
       OrtalamaBirimFiyat, ToplamSiparisMiktari, ToplamGelenMiktar
FROM dbo.vw_SpendAnalysis
ORDER BY ToplamSiparisTutari DESC;

-- 4) OTD Orani (tedarikci skor karti icin)
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
) t 
GROUP BY TedarikciAdi
ORDER BY OTD_Yuzde DESC;

-- 5) Aylik Siparis Trendi (cizgi grafik)
SELECT FORMAT(SiparisTarihi, 'yyyy-MM') AS Ay, COUNT(DISTINCT SiparisNo) AS SiparisSayisi, SUM(SiparisTutari) AS ToplamTutar
FROM dbo.vw_FulfillmentStatus 
GROUP BY FORMAT(SiparisTarihi, 'yyyy-MM') 
ORDER BY Ay;

-- 6) Urun Bazinda Harcama (sutun grafik)
SELECT MalzemeNo, MalzemeAciklamasi, UrunTipi, SUM(SiparisMiktari) AS ToplamMiktar, SUM(SiparisTutari) AS ToplamTutar
FROM dbo.vw_FulfillmentStatus 
GROUP BY MalzemeNo, MalzemeAciklamasi, UrunTipi 
ORDER BY ToplamTutar DESC;

-- 7) Acik Siparisler (yolda - tablo visual)
SELECT SiparisNo, TedarikciAdi, KalemNo, MalzemeAciklamasi, SiparisMiktari, AcikMiktar, TaahhutTarihi, SiparisTarihi
FROM dbo.vw_FulfillmentStatus 
WHERE TeslimatDurumu = N'Açık' 
ORDER BY TaahhutTarihi;

-- 8) Gecikmeli Teslimler (tablo + gecikme gunu)
SELECT SiparisNo, KalemNo, TedarikciAdi, TaahhutTarihi, FiiliTeslimTarihi, GecikmeGunu, SiparisMiktari, GelenMiktar
FROM dbo.vw_VendorOTDPerformance 
WHERE GecikmeGunu > 0 
ORDER BY GecikmeGunu DESC;

-- 9) Kismi Teslimler (acik kalan miktar analizi)
SELECT SiparisNo, KalemNo, TedarikciAdi, MalzemeAciklamasi, SiparisMiktari, GelenMiktar, AcikMiktar, KarsilanmaOraniYuzde
FROM dbo.vw_FulfillmentStatus 
WHERE TeslimatDurumu = N'Kısmi' 
ORDER BY KarsilanmaOraniYuzde;

-- 10) Ulke Bazinda Harcama (harita visual icin)
SELECT Ulke, COUNT(DISTINCT TedarikciNo) AS TedarikciSayisi, SUM(ToplamSiparisTutari) AS ToplamTutar
FROM dbo.vw_SpendAnalysis
GROUP BY Ulke;
