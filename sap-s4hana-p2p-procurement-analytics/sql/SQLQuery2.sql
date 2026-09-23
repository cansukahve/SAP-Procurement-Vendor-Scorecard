-- 1. Teslimat Karþýlama Durumu (Tam, Kýsmi, Açýk)
SELECT TOP 10 * FROM vw_FulfillmentStatus;

-- 2. Tedarikçi Zamanýnda Teslimat Performansý (OTD & Gecikme Günleri)
SELECT TOP 10 * FROM vw_VendorOTDPerformance;

-- 3. Tedarikçi Bazlý Toplam Harcama Analizi
SELECT * FROM vw_SpendAnalysis;

ALTER VIEW vw_FulfillmentStatus AS
SELECT 
    p.ebeln AS SiparisNo,
    p.ebelp AS KalemNo,
    h.lifnr AS TedarikciNo,
    v.name1 AS TedarikciAdi,
    v.land1 AS Ulke,
    v.ort01 AS Sehir,
    p.matnr AS MalzemeNo,
    m.maktx AS MalzemeAciklamasi,
    m.mtart AS UrunTipi,
    m.meins AS Birim,
    h.bedat AS SiparisTarihi,
    p.eindt AS TaahhutTarihi,
    p.menge AS SiparisMiktari,
    p.netpr AS BirimFiyat,
    (p.menge * p.netpr) AS SiparisTutari,
    ISNULL(g.MengeToplam, 0) AS GelenMiktar,
    (p.menge - ISNULL(g.MengeToplam, 0)) AS AcikMiktar,
    CASE 
        WHEN ISNULL(g.MengeToplam, 0) = 0 THEN N'Açýk'
        WHEN ISNULL(g.MengeToplam, 0) < p.menge THEN N'Kýsmi'
        ELSE N'Tam'
    END AS TeslimatDurumu
FROM EKPO p
JOIN EKKO h ON p.ebeln = h.ebeln
JOIN LFA1 v ON h.lifnr = v.lifnr
JOIN MARA m ON p.matnr = m.matnr
LEFT JOIN (
     SELECT ebeln, ebelp, SUM(menge) AS MengeToplam
    FROM MSEG
    WHERE bwart = '101'
    GROUP BY ebeln, ebelp
) g ON p.ebeln = g.ebeln AND p.ebelp = g.ebelp;



SELECT 
    v.TedarikciNo,
    v.TedarikciAdi,
    COUNT(*) AS ToplamTeslimat,
    SUM(CASE WHEN v.TeslimatDurumu = N'Zamanýnda' THEN 1 ELSE 0 END) AS ZamanindaTeslimat,
    ROUND(
        CAST(SUM(CASE WHEN v.TeslimatDurumu = N'Zamanýnda' THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(*) * 100, 2
    ) AS [OTD_Orani_%],
    CASE 
        WHEN (CAST(SUM(CASE WHEN v.TeslimatDurumu = N'Zamanýnda' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*)) >= 0.85 THEN 'A (Güvenilir)'
        WHEN (CAST(SUM(CASE WHEN v.TeslimatDurumu = N'Zamanýnda' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*)) >= 0.65 THEN 'B (Ýzlenmeli)'
        ELSE 'C (Kritik / Riskli)'
    END AS TedarikciSegmenti
FROM vw_VendorOTDPerformance v
WHERE v.TeslimatDurumu IN (N'Zamanýnda', N'Gecikmeli')
GROUP BY v.TedarikciNo, v.TedarikciAdi;


SELECT 
    v.TedarikciNo,
    v.TedarikciAdi,
    COUNT(*) AS ToplamTeslimat,
    SUM(CASE WHEN v.GecikmeGunu <= 0 THEN 1 ELSE 0 END) AS ZamanindaTeslimat,
    ROUND(
        CAST(SUM(CASE WHEN v.GecikmeGunu <= 0 THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(*) * 100, 2
    ) AS [OTD_Orani_%],
    CASE 
        WHEN (CAST(SUM(CASE WHEN v.GecikmeGunu <= 0 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*)) >= 0.85 THEN 'A (Güvenilir)'
        WHEN (CAST(SUM(CASE WHEN v.GecikmeGunu <= 0 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*)) >= 0.65 THEN 'B (Ýzlenmeli)'
        ELSE 'C (Kritik / Riskli)'
    END AS TedarikciSegmenti
FROM vw_VendorOTDPerformance v
WHERE v.FiiliTeslimTarihi IS NOT NULL
GROUP BY v.TedarikciNo, v.TedarikciAdi;


CREATE OR ALTER VIEW vw_VendorScorecard AS
SELECT 
    v.TedarikciNo,
    v.TedarikciAdi,
    COUNT(*) AS ToplamTeslimat,
    SUM(CASE WHEN v.GecikmeGunu <= 0 THEN 1 ELSE 0 END) AS ZamanindaTeslimat,
    ROUND(
        CAST(SUM(CASE WHEN v.GecikmeGunu <= 0 THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(*) * 100, 2
    ) AS OTD_Orani,
    CASE 
        WHEN (CAST(SUM(CASE WHEN v.GecikmeGunu <= 0 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*)) >= 0.85 THEN 'A (Güvenilir)'
        WHEN (CAST(SUM(CASE WHEN v.GecikmeGunu <= 0 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*)) >= 0.65 THEN 'B (Ýzlenmeli)'
        ELSE 'C (Kritik / Riskli)'
    END AS TedarikciSegmenti
FROM vw_VendorOTDPerformance v
WHERE v.FiiliTeslimTarihi IS NOT NULL
GROUP BY v.TedarikciNo, v.TedarikciAdi;