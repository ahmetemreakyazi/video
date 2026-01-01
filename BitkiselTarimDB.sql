-- BitkiselTarimDB SQL Projesi

CREATE DATABASE BitkiselTarimDB;
GO
USE BitkiselTarimDB;
GO

CREATE TABLE CIFTCI(
    CiftciID INT IDENTITY PRIMARY KEY,
    Ad NVARCHAR(50),
    Soyad NVARCHAR(50)
);

CREATE TABLE TARLA(
    TarlaID INT IDENTITY PRIMARY KEY,
    CiftciID INT,
    AlanDonum DECIMAL(10,2),
    FOREIGN KEY (CiftciID) REFERENCES CIFTCI(CiftciID)
);

CREATE TABLE URUN(
    UrunID INT IDENTITY PRIMARY KEY,
    UrunAdi NVARCHAR(50)
);

CREATE TABLE SATIS(
    SatisID INT IDENTITY PRIMARY KEY,
    ToplamTutar DECIMAL(10,2)
);

CREATE TABLE SATIS_KALEM(
    KalemID INT IDENTITY PRIMARY KEY,
    SatisID INT,
    UrunID INT,
    MiktarKg DECIMAL(10,2),
    BirimFiyat DECIMAL(10,2),
    FOREIGN KEY (SatisID) REFERENCES SATIS(SatisID),
    FOREIGN KEY (UrunID) REFERENCES URUN(UrunID)
);

CREATE PROCEDURE sp_SatisBaslat
AS
BEGIN
    INSERT INTO SATIS(ToplamTutar) VALUES (0);
END;
GO

CREATE TRIGGER trg_SatisToplam
ON SATIS_KALEM
AFTER INSERT
AS
BEGIN
    UPDATE SATIS
    SET ToplamTutar = ToplamTutar +
        (SELECT SUM(MiktarKg * BirimFiyat) FROM inserted)
    WHERE SatisID IN (SELECT SatisID FROM inserted);
END;
GO
