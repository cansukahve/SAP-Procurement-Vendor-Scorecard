-- ============================================================================
-- 02_seed_MARA.sql
-- MARA (Malzemeler) - Nova Teknoloji elektronik perakende urunleri
-- En az 15 urun: HAWA (ticari mallar) + ROH (yedek parca/kablo)
-- Burada 16 urun: 10 HAWA + 6 ROH, ST (adet) biriminde
-- ============================================================================
SET NOCOUNT ON;
PRINT N'--- 02_seed_MARA: Basladi ---';

INSERT INTO dbo.MARA (matnr, maktx, mtart, meins) VALUES
-- HAWA - Ticari Mallar (satis urunleri)
('MAT-NB01', 'NovaBook Pro 14 M1 16GB/512GB',        'HAWA', 'ST'),
('MAT-NB02', 'NovaBook Air 13 M2 8GB/256GB',         'HAWA', 'ST'),
('MAT-MN01', 'Apex Monitor 27" 4K IPS 144Hz',        'HAWA', 'ST'),
('MAT-MN02', 'Apex Monitor 32" Curved 4K',           'HAWA', 'ST'),
('MAT-HP01', 'Pulse Kulaklik ANC Pro Wireless',      'HAWA', 'ST'),
('MAT-HP02', 'Pulse Kulaklik Lite Bluetooth',        'HAWA', 'ST'),
('MAT-TB01', 'NovaTab 11 128GB WiFi Tablet',         'HAWA', 'ST'),
('MAT-PH01', 'NovaPhone X 256GB Akilli Telefon',     'HAWA', 'ST'),
('MAT-SP01', 'Nova Soundbar 2.1 120W',               'HAWA', 'ST'),
('MAT-CM01', 'NovaCam 4K Aksiyon Kamerasi',          'HAWA', 'ST'),
-- ROH - Yedek parca / Sarf / Kablo / Aksesuar
('MAT-CB01', 'USB-C Orgulu Sarj Kablosu 2m',         'ROH',  'ST'),
('MAT-CB02', 'HDMI 2.1 Yuksek Hiz Kablosu 2m',       'ROH',  'ST'),
('MAT-AD01', '65W GaN Hizli Sarj Adaptoru',          'ROH',  'ST'),
('MAT-AD02', '100W GaN Hizli Sarj Adaptoru',         'ROH',  'ST'),
('MAT-MS01', 'Kablosuz Ergonomik Mouse',             'ROH',  'ST'),
('MAT-KB01', 'Mekanik Kablosuz Klavye RGB',          'ROH',  'ST');

SELECT COUNT(*) AS MARA_KayitSayisi FROM dbo.MARA;
SELECT matnr AS MalzemeNo, maktx AS MalzemeAciklamasi, mtart AS UrunTipi, meins AS Birim FROM dbo.MARA ORDER BY matnr;

PRINT N'--- 02_seed_MARA: Tamamlandi (16 urun) ---';
GO
