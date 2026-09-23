# SAP S/4HANA P2P Procurement Analytics - Nova Teknoloji Ltd. Şti.

Elektronik perakende senaryosu icin `CANSU\SQLEXPRESS02` uzerindeki `SAP_Procurement` veritabanina zenginlestirilmis veri seti ve analitik View katmani.

## Mimari
- **Instance:** `CANSU\SQLEXPRESS02` / DB: `SAP_Procurement` (Turkish_CI_AS)
- **Tablolar:** `MARA, LFA1, EKKO, EKPO, MSEG` (FK: EKKO->LFA1, EKPO->EKKO+MARA, MSEG->EKPO composite)
- **Viewlar:** `vw_FulfillmentStatus`, `vw_VendorOTDPerformance`, `vw_SpendAnalysis` (Turkce kolon aliaslari)

## Veri Hacmi (Guncel Build Sonrasi)
- MARA: 16 urun (10 HAWA + 6 ROH) - NovaBook, Apex Monitor, Pulse Kulaklik, NovaPhone vb.
- LFA1: 7 hayali kurumsal tedarikci (4 TR + DE/CN/US)
- EKKO: 12 siparis (2024-11-05 .. 2025-02-10)
- EKPO: 29 kalem (menge, netpr, eindt dolu)
- MSEG: 22 mal girisi bwart='101' (20 kalemi kapsar, 9 kalem acik/yolda)
  - A) Zamaninda Tam: 8 kayit
  - B) Kismi: 6 kalem (8 fiziksel satir - 2 kalem cift giris)
  - C) Gecikmeli: 6 kayit (DATEDIFF pozitif, budat > eindt)
  - D) Acik/Yolda: 9 kalem (MSEG yok)

## Klasor Yapisi
```
sql/
  00_master_build.sql      -> Tek tikla tum build (:r ile modulleri calistirir)
  01_cleanup.sql           -> View drop + FK sirasinda DELETE
  02_seed_MARA.sql
  03_seed_LFA1.sql
  04_seed_EKKO.sql
  05_seed_EKPO.sql
  06_seed_MSEG.sql         -> 4 senaryo dokumante
  07_create_views.sql      -> 3 view DDL (CREATE OR ALTER mantigi)
  08_verify.sql            -> Sayim + senaryo dagilim + Power BI sorgulari
  09_powerbi_queries.sql   -> Power BI icin 10 hazir SELECT
```

## Kurulum

### Yontem 1: Master Build (onerilen)
```powershell
sqlcmd -S "CANSU\SQLEXPRESS02" -d SAP_Procurement -i "sql\00_master_build.sql"
```
> Not: `00_master_build.sql` icindeki `:r` komutlari relative path kullanir. Calisir dizin `sql/` olmali veya sqlcmd'yi `sql` klasorunden calistirin:
```powershell
Set-Location "C:\Users\Lenovo\Desktop\sap-s4hana-p2p-procurement-analytics\sql"
sqlcmd -S "CANSU\SQLEXPRESS02" -d SAP_Procurement -i 00_master_build.sql
```

### Yontem 2: Adim adim
```powershell
sqlcmd -S "CANSU\SQLEXPRESS02" -d SAP_Procurement -i sql\01_cleanup.sql
sqlcmd -S "CANSU\SQLEXPRESS02" -d SAP_Procurement -i sql\02_seed_MARA.sql
sqlcmd -S "CANSU\SQLEXPRESS02" -d SAP_Procurement -i sql\03_seed_LFA1.sql
sqlcmd -S "CANSU\SQLEXPRESS02" -d SAP_Procurement -i sql\04_seed_EKKO.sql
sqlcmd -S "CANSU\SQLEXPRESS02" -d SAP_Procurement -i sql\05_seed_EKPO.sql
sqlcmd -S "CANSU\SQLEXPRESS02" -d SAP_Procurement -i sql\06_seed_MSEG.sql
sqlcmd -S "CANSU\SQLEXPRESS02" -d SAP_Procurement -i sql\07_create_views.sql
sqlcmd -S "CANSU\SQLEXPRESS02" -d SAP_Procurement -i sql\08_verify.sql
```

## View Tanımlari

### vw_FulfillmentStatus
Her EKPO kalemi icin `SiparisMiktari, GelenMiktar, AcikMiktar, SiparisTutari, KarsilanmaOraniYuzde, TeslimatDurumu (Tam/Kismi/Acik), SonTeslimTarihi`. Power BI ana fact tablosu.

### vw_VendorOTDPerformance
Her MSEG satiri icin `GecikmeGunu = DATEDIFF(DAY, TaahhutTarihi, FiiliTeslimTarihi)`, `TeslimatDurumu (Zamaninda/Gecikmeli/Acik)`. Cok parcali teslimlerde birden fazla satir uretir.

### vw_SpendAnalysis
Tedarikci ozet: `SiparisSayisi, KalemSayisi, ToplamSiparisTutari, ToplamGelenTutari, AcikTutar, OrtalamaBirimFiyat`.

## Power BI Baglantisi
1. Power BI Desktop > Get Data > SQL Server
2. Server: `CANSU\SQLEXPRESS02`, Database: `SAP_Procurement`
3. Import modunda `vw_FulfillmentStatus`, `vw_VendorOTDPerformance`, `vw_SpendAnalysis` secin veya `09_powerbi_queries.sql` icindeki sorgulari kullanin.
4. Iliski: `vw_FulfillmentStatus[SiparisNo]` <-> `vw_VendorOTDPerformance[SiparisNo]` (many-to-many degil, kalem bazli join icin SiparisNo+KalemNo kullanin)

## Dogrulama
```sql
SELECT * FROM dbo.vw_FulfillmentStatus ORDER BY SiparisNo, KalemNo;
SELECT * FROM dbo.vw_VendorOTDPerformance WHERE GecikmeGunu > 0 ORDER BY GecikmeGunu DESC;
SELECT * FROM dbo.vw_SpendAnalysis ORDER BY ToplamSiparisTutari DESC;
```
`08_verify.sql` calistirilarak tum senaryolarin dagilimi otomatik kontrol edilir.

## Notlar
- Tum isimler kurgusal/hayali, gercek marka icermez.
- Fiyatlar TL, tarihler 2024-11..2025-02.
- FK iliskileri korunur, cleanup silme sirasi MSEG->EKPO->EKKO->LFA1/MARA.
