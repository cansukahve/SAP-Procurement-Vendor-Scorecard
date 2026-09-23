-- ============================================================================
-- 03_seed_LFA1.sql
-- LFA1 (Tedarikciler) - En az 6 yerli/yabanci kurumsal tedarikci
-- Burada 7 tedarikci: 4 TR + 1 DE + 1 CN + 1 US
-- Tamamen kurgusal/hayali ama kurumsal isimler (gercek marka yok)
-- ============================================================================
SET NOCOUNT ON;
PRINT N'--- 03_seed_LFA1: Basladi ---';

INSERT INTO dbo.LFA1 (lifnr, name1, land1, ort01) VALUES
-- Yerli tedarikciler (TR)
('VEND-TR01', 'TeknoTedarik Dagitim A.S.',           'TR', 'Istanbul'),
('VEND-TR02', 'Kuzey Bilisim Sistemleri Ltd. Sti.',  'TR', 'Ankara'),
('VEND-TR03', 'Ege Teknoloji Lojistik A.S.',         'TR', 'Izmir'),
('VEND-TR04', 'Atlas Komponent Sanayi A.S.',         'TR', 'Bursa'),
-- Yabanci tedarikciler
('VEND-DE01', 'Alfa Elektronik B.V.',                'DE', 'Munich'),
('VEND-CN01', 'NovaTech Components Ltd.',            'CN', 'Shenzhen'),
('VEND-US01', 'Pine Valley Systems Inc.',            'US', 'Austin');

SELECT COUNT(*) AS LFA1_KayitSayisi FROM dbo.LFA1;
SELECT lifnr AS TedarikciNo, name1 AS TedarikciAdi, land1 AS Ulke, ort01 AS Sehir FROM dbo.LFA1 ORDER BY lifnr;

PRINT N'--- 03_seed_LFA1: Tamamlandi (7 tedarikci) ---';
GO
