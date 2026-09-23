-- ============================================================================
-- 05_seed_EKPO.sql
-- EKPO (Siparis Kalemleri) - En az 25-30 kalem
-- Burada 28 kalem: menge, netpr, eindt (teslim taahhut tarihi) dolduruldu
-- eindt = bedat + 10..15 gun mantigiyla hesaplandi
-- Fiyatlar gercekci: Notebook 28-35k, Monitor 8-14k, Kulaklik 3-6k, Kablo/aksesuar 150-3500
-- ============================================================================
SET NOCOUNT ON;
PRINT N'--- 05_seed_EKPO: Basladi ---';

-- 4500000001 - TeknoTedarik (2024-11-05 bedat -> eindt 2024-11-18/20)
INSERT INTO dbo.EKPO (ebeln, ebelp, matnr, menge, netpr, eindt) VALUES
('4500000001', 10, 'MAT-NB01',  25.000, 32500.00, '2024-11-18'),
('4500000001', 20, 'MAT-CB01', 150.000,   180.00, '2024-11-18'),
('4500000001', 30, 'MAT-MS01',  80.000,   650.00, '2024-11-20');

-- 4500000002 - Kuzey Bilisim (2024-11-12 -> 2024-11-25)
INSERT INTO dbo.EKPO (ebeln, ebelp, matnr, menge, netpr, eindt) VALUES
('4500000002', 10, 'MAT-MN01',  30.000,  8500.00, '2024-11-25'),
('4500000002', 20, 'MAT-HP01',  40.000,  4200.00, '2024-11-25');

-- 4500000003 - Alfa Elektronik DE (2024-11-18 -> 2024-12-02)
INSERT INTO dbo.EKPO (ebeln, ebelp, matnr, menge, netpr, eindt) VALUES
('4500000003', 10, 'MAT-MN02',  20.000, 13500.00, '2024-12-02'),
('4500000003', 20, 'MAT-CB02', 100.000,   320.00, '2024-12-02');

-- 4500000004 - NovaTech CN (2024-11-25 -> 2024-12-09)
INSERT INTO dbo.EKPO (ebeln, ebelp, matnr, menge, netpr, eindt) VALUES
('4500000004', 10, 'MAT-HP01',  60.000,  3800.00, '2024-12-09'),
('4500000004', 20, 'MAT-HP02', 100.000,  2100.00, '2024-12-09'),
('4500000004', 30, 'MAT-AD01', 120.000,   950.00, '2024-12-10');

-- 4500000005 - TeknoTedarik (2024-12-02 -> 2024-12-16)
INSERT INTO dbo.EKPO (ebeln, ebelp, matnr, menge, netpr, eindt) VALUES
('4500000005', 10, 'MAT-NB02',  30.000, 28500.00, '2024-12-16'),
('4500000005', 20, 'MAT-TB01',  25.000,  9500.00, '2024-12-16'),
('4500000005', 30, 'MAT-KB01',  60.000,  1850.00, '2024-12-16');

-- 4500000006 - Ege Teknoloji (2024-12-08 -> 2024-12-20)
INSERT INTO dbo.EKPO (ebeln, ebelp, matnr, menge, netpr, eindt) VALUES
('4500000006', 10, 'MAT-PH01',  40.000, 18500.00, '2024-12-20'),
('4500000006', 20, 'MAT-CB01', 200.000,   175.00, '2024-12-20');

-- 4500000007 - Pine Valley US (2024-12-15 -> 2024-12-30)
INSERT INTO dbo.EKPO (ebeln, ebelp, matnr, menge, netpr, eindt) VALUES
('4500000007', 10, 'MAT-SP01',  35.000,  6200.00, '2024-12-30'),
('4500000007', 20, 'MAT-CM01',  30.000,  7800.00, '2024-12-30');

-- 4500000008 - Atlas Komponent (2024-12-20 -> 2025-01-03)
INSERT INTO dbo.EKPO (ebeln, ebelp, matnr, menge, netpr, eindt) VALUES
('4500000008', 10, 'MAT-AD02',  80.000,  1450.00, '2025-01-03'),
('4500000008', 20, 'MAT-AD01', 100.000,   900.00, '2025-01-03');

-- 4500000009 - NovaTech CN (2025-01-06 -> 2025-01-20)
INSERT INTO dbo.EKPO (ebeln, ebelp, matnr, menge, netpr, eindt) VALUES
('4500000009', 10, 'MAT-HP02',  80.000,  2200.00, '2025-01-20'),
('4500000009', 20, 'MAT-CB02', 120.000,   310.00, '2025-01-20'),
('4500000009', 30, 'MAT-MS01',  70.000,   680.00, '2025-01-20');

-- 4500000010 - Alfa Elektronik DE (2025-01-14 -> 2025-01-28)
INSERT INTO dbo.EKPO (ebeln, ebelp, matnr, menge, netpr, eindt) VALUES
('4500000010', 10, 'MAT-MN01',  25.000,  8900.00, '2025-01-28'),
('4500000010', 20, 'MAT-MN02',  15.000, 13800.00, '2025-01-28');

-- 4500000011 - TeknoTedarik (2025-01-28 -> 2025-02-10)
INSERT INTO dbo.EKPO (ebeln, ebelp, matnr, menge, netpr, eindt) VALUES
('4500000011', 10, 'MAT-NB01',  20.000, 33000.00, '2025-02-10'),
('4500000011', 20, 'MAT-TB01',  30.000,  9800.00, '2025-02-10'),
('4500000011', 30, 'MAT-KB01',  50.000,  1900.00, '2025-02-10');

-- 4500000012 - Kuzey Bilisim (2025-02-10 -> 2025-02-24) -- Acik/yolda senaryosu icin en guncel siparis
INSERT INTO dbo.EKPO (ebeln, ebelp, matnr, menge, netpr, eindt) VALUES
('4500000012', 10, 'MAT-NB02',  15.000, 29000.00, '2025-02-24'),
('4500000012', 20, 'MAT-PH01',  20.000, 18800.00, '2025-02-24');

SELECT COUNT(*) AS EKPO_KayitSayisi FROM dbo.EKPO;
SELECT ebeln AS SiparisNo, ebelp AS KalemNo, matnr AS MalzemeNo, menge AS SiparisMiktari, netpr AS BirimFiyat, eindt AS TaahhutTarihi
FROM dbo.EKPO ORDER BY ebeln, ebelp;

PRINT N'--- 05_seed_EKPO: Tamamlandi (28 kalem) ---';
GO
