-- ============================================================================
-- 06_seed_MSEG.sql
-- MSEG (Depo Hareketleri / Mal Kabul) - En az 20-25 mal girisi (bwart='101')
-- Burada 22 kayit; 20 EKPO kalemini kapsar, 9 kalem acik/yolda birakilir
-- 4 Senaryo dagilimi:
--   A) Zamaninda & Tam      : 8 kayit  (budat <= eindt, menge = siparis)
--   B) Kismi Teslim         : 6 kalem (4 tek parca + 2 cift parca = 8 satir)
--   C) Gecikmeli            : 6 kayit  (budat > eindt, DATEDIFF pozitif)
--   D) Acik/Yolda (MSEG yok): 9 kalem (4500000001/05/09/10/11/12 dagilimi) -> MSEG'e yazilmaz
-- mblnr 5000000001.. sirali, mjahr = YEAR(budat), zeile=1 (cok parcalida 1,2)
-- ============================================================================
SET NOCOUNT ON;
PRINT N'--- 06_seed_MSEG: Basladi ---';

-- ===================== A) ZAMANINDA VE TAM TESLIM (8 kayit) =====================
-- Budat <= Eindt ve tam miktar
INSERT INTO dbo.MSEG (mblnr, mjahr, zeile, bwart, ebeln, ebelp, menge, bldat, budat) VALUES
('5000000001', '2024', 1, '101', '4500000001', 10,  25.000, '2024-11-17', '2024-11-17'), -- eindt 11-18 -> 1 gun erken
('5000000002', '2024', 1, '101', '4500000001', 20, 150.000, '2024-11-16', '2024-11-16'), -- eindt 11-18 -> 2 gun erken
('5000000003', '2024', 1, '101', '4500000002', 10,  30.000, '2024-11-24', '2024-11-24'), -- eindt 11-25 -> 1 gun erken
('5000000004', '2024', 1, '101', '4500000003', 20, 100.000, '2024-12-01', '2024-12-01'), -- eindt 12-02 -> 1 gun erken
('5000000005', '2024', 1, '101', '4500000005', 10,  30.000, '2024-12-15', '2024-12-15'), -- eindt 12-16 -> 1 gun erken
('5000000006', '2024', 1, '101', '4500000006', 20, 200.000, '2024-12-19', '2024-12-19'), -- eindt 12-20 -> 1 gun erken
('5000000007', '2024', 1, '101', '4500000008', 10,  80.000, '2025-01-02', '2025-01-02'), -- eindt 01-03 -> 1 gun erken (2025 mjahr!)
('5000000008', '2025', 1, '101', '4500000009', 20, 120.000, '2025-01-19', '2025-01-19'); -- eindt 01-20 -> 1 gun erken
-- Not: 5000000007 icin mjahr yanlis yazildi, duzeltiliyor (budat 2025-01-02 => mjahr 2025 olmali)
-- Bu kaydi duzelt:
DELETE FROM dbo.MSEG WHERE mblnr='5000000007';
INSERT INTO dbo.MSEG (mblnr, mjahr, zeile, bwart, ebeln, ebelp, menge, bldat, budat) VALUES
('5000000007', '2025', 1, '101', '4500000008', 10,  80.000, '2025-01-02', '2025-01-02');

-- ===================== C) GECIKMELI TESLIM (5 kayit) =====================
-- Budat > Eindt, tam miktar ama gec
INSERT INTO dbo.MSEG (mblnr, mjahr, zeile, bwart, ebeln, ebelp, menge, bldat, budat) VALUES
('5000000009', '2024', 1, '101', '4500000002', 20,  40.000, '2024-12-02', '2024-12-02'), -- eindt 11-25 -> 7 gun gec
('5000000010', '2024', 1, '101', '4500000004', 10,  60.000, '2024-12-15', '2024-12-15'), -- eindt 12-09 -> 6 gun gec
('5000000011', '2024', 1, '101', '4500000005', 30,  60.000, '2024-12-22', '2024-12-22'), -- eindt 12-16 -> 6 gun gec
('5000000012', '2025', 1, '101', '4500000007', 10,  35.000, '2025-01-05', '2025-01-05'), -- eindt 12-30 -> 6 gun gec
('5000000013', '2025', 1, '101', '4500000010', 10,  25.000, '2025-02-04', '2025-02-04'); -- eindt 01-28 -> 7 gun gec

-- ===================== B) KISMI TESLIM (5 kalem, 7 satir) =====================
-- Siparis miktarinin altinda teslim
-- Tek parca kismi (3 kalem)
INSERT INTO dbo.MSEG (mblnr, mjahr, zeile, bwart, ebeln, ebelp, menge, bldat, budat) VALUES
('5000000014', '2024', 1, '101', '4500000003', 10,  12.000, '2024-12-01', '2024-12-01'), -- 20 siparis -> 12 geldi (8 acik)
('5000000015', '2024', 1, '101', '4500000006', 10,  25.000, '2024-12-19', '2024-12-19'), -- 40 siparis -> 25 geldi (15 acik)
('5000000016', '2025', 1, '101', '4500000009', 10,  50.000, '2025-01-18', '2025-01-18'); -- 80 siparis -> 50 geldi (30 acik)

-- Iki parcali kismi (2 kalem -> her biri 2 satir = 4 satir)
-- 4500000004-20: 100 siparis -> 60+20 = 80 geldi (20 acik)
INSERT INTO dbo.MSEG (mblnr, mjahr, zeile, bwart, ebeln, ebelp, menge, bldat, budat) VALUES
('5000000017', '2024', 1, '101', '4500000004', 20,  60.000, '2024-12-08', '2024-12-08'),
('5000000017', '2024', 2, '101', '4500000004', 20,  20.000, '2024-12-09', '2024-12-09');
-- 4500000004-30: 120 siparis -> 70+30 = 100 geldi (20 acik)
INSERT INTO dbo.MSEG (mblnr, mjahr, zeile, bwart, ebeln, ebelp, menge, bldat, budat) VALUES
('5000000018', '2024', 1, '101', '4500000004', 30,  70.000, '2024-12-09', '2024-12-09'),
('5000000018', '2024', 2, '101', '4500000004', 30,  30.000, '2024-12-10', '2024-12-10');

-- ===================== Ek Gecikmeli + Kismi (22'ye tamamlamak icin) =====================
INSERT INTO dbo.MSEG (mblnr, mjahr, zeile, bwart, ebeln, ebelp, menge, bldat, budat) VALUES
('5000000019', '2025', 1, '101', '4500000008', 20, 100.000, '2025-01-04', '2025-01-04'), -- eindt 01-03 -> 1 gun gecikmeli tam (ATLAS)
('5000000020', '2024', 1, '101', '4500000007', 20,  20.000, '2024-12-28', '2024-12-28'); -- 30 siparis -> 20 geldi kismi (erken ama eksik)

-- ===================== D) ACIK/YOLDA (MSEG yok - 9 kalem) =====================
-- Asagidaki EKPO kalemleri icin HIC MSEG kaydi olusturulmadi (bilerek):
--   4500000001-30 (MAT-MS01 80), 4500000005-20 (MAT-TB01 25),
--   4500000009-30 (MAT-MS01 70), 4500000010-20 (MAT-MN02 15),
--   4500000011-* (3 kalem), 4500000012-* (2 kalem)
-- Toplam 9 kalem acik! MSEG'li kalem = 20, acik = 9 -> 29 toplam dogru.
-- 22 MSEG satiri (fiziksel row) ama 20 EKPO kalemini kapsar.
-- 4 Senaryo dagilimi guncel: A)8 tam, B)6 kismi (4 tek+2 cift), C)6 gecikmeli, D)9 acik

-- Dogrulama sorgulari
SELECT COUNT(*) AS MSEG_FizikselSatirSayisi FROM dbo.MSEG;
SELECT COUNT(DISTINCT CONCAT(ebeln,'-',ebelp)) AS MSEG_KapsananKalemSayisi FROM dbo.MSEG;
SELECT COUNT(*) AS EKPO_Toplam FROM dbo.EKPO;
SELECT COUNT(*) AS AcikKalemSayisi FROM dbo.EKPO p
WHERE NOT EXISTS (SELECT 1 FROM dbo.MSEG g WHERE g.ebeln=p.ebeln AND g.ebelp=p.ebelp);

-- Senaryo ozeti
SELECT
  CASE WHEN g.ebeln IS NULL THEN 'D) Acik/Yolda'
       WHEN SUM(g.menge) < p.menge THEN 'B) Kismi'
       WHEN MAX(g.budat) > p.eindt THEN 'C) Gecikmeli'
       ELSE 'A) Zamaninda Tam' END AS Senaryo,
  COUNT(*) AS KalemSayisi
FROM dbo.EKPO p
LEFT JOIN (SELECT ebeln, ebelp, menge, budat FROM dbo.MSEG) g ON p.ebeln=g.ebeln AND p.ebelp=g.ebelp
GROUP BY p.ebeln, p.ebelp, p.menge, p.eindt, g.ebeln;

PRINT N'--- 06_seed_MSEG: Tamamlandi (22 fiziksel satir, 20 kalem kapsar, 9 kalem acik) ---';
GO
