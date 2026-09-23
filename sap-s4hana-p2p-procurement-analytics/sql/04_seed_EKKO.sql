-- ============================================================================
-- 04_seed_EKKO.sql
-- EKKO (Satin Alma Siparis Basliklari) - En az 10-12 siparis
-- Burada 12 siparis: 2024-11-01 ile 2025-02-15 arasi
-- bukrs=1000 (Nova Teknoloji), ekorg=TR01 sabit
-- Her tedarikciye en az 1 siparis, TeknoTedarik'e 3 siparis
-- ============================================================================
SET NOCOUNT ON;
PRINT N'--- 04_seed_EKKO: Basladi ---';

INSERT INTO dbo.EKKO (ebeln, lifnr, bedat, ekorg, bukrs) VALUES
('4500000001', 'VEND-TR01', '2024-11-05', 'TR01', '1000'),
('4500000002', 'VEND-TR02', '2024-11-12', 'TR01', '1000'),
('4500000003', 'VEND-DE01', '2024-11-18', 'TR01', '1000'),
('4500000004', 'VEND-CN01', '2024-11-25', 'TR01', '1000'),
('4500000005', 'VEND-TR01', '2024-12-02', 'TR01', '1000'),
('4500000006', 'VEND-TR03', '2024-12-08', 'TR01', '1000'),
('4500000007', 'VEND-US01', '2024-12-15', 'TR01', '1000'),
('4500000008', 'VEND-TR04', '2024-12-20', 'TR01', '1000'),
('4500000009', 'VEND-CN01', '2025-01-06', 'TR01', '1000'),
('4500000010', 'VEND-DE01', '2025-01-14', 'TR01', '1000'),
('4500000011', 'VEND-TR01', '2025-01-28', 'TR01', '1000'),
('4500000012', 'VEND-TR02', '2025-02-10', 'TR01', '1000');

SELECT COUNT(*) AS EKKO_KayitSayisi FROM dbo.EKKO;
SELECT ebeln AS SiparisNo, lifnr AS TedarikciNo, bedat AS SiparisTarihi, ekorg AS SatinAlmaOrg, bukrs AS SirketKodu
FROM dbo.EKKO ORDER BY ebeln;

PRINT N'--- 04_seed_EKKO: Tamamlandi (12 siparis) ---';
GO
