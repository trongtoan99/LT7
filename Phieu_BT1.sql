CREATE TABLE KHOA (
    Makhoa VARCHAR2(10) PRIMARY KEY,
    Tenkhoa VARCHAR2(100),
    Dienthoai VARCHAR2(15)
);

CREATE TABLE LOP (
    Malop VARCHAR2(10) PRIMARY KEY,
    Tenlop VARCHAR2(100),
    Khoa VARCHAR2(50),
    Hedt VARCHAR2(50),
    Namnhaphoc NUMBER(4),
    Makhoa VARCHAR2(10),
    FOREIGN KEY (Makhoa) REFERENCES KHOA(Makhoa)
);


CREATE OR REPLACE PROCEDURE them_khoa (
    p_makhoa IN VARCHAR2,
    p_tenkhoa IN VARCHAR2,
    p_dienthoai IN VARCHAR2
) AS
    v_dem NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_dem FROM KHOA WHERE Tenkhoa = p_tenkhoa;

    IF v_dem > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ten khoa da ton tai');
    ELSE
        INSERT INTO KHOA VALUES (p_makhoa, p_tenkhoa, p_dienthoai);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Them khoa thanh cong');
    END IF;
END them_khoa;
/
--
SET SERVEROUTPUT ON;

BEGIN
    them_khoa('CNTT', 'Cong nghe thong tin', '0123456789');
END;
/

BEGIN
    them_khoa('CNTT2', 'Cong nghe thong tin', '0987654321');
END;
/

--
CREATE OR REPLACE PROCEDURE them_lop (
    p_malop IN VARCHAR2,
    p_tenlop IN VARCHAR2,
    p_khoa IN VARCHAR2,
    p_hedt IN VARCHAR2,
    p_namnhaphoc IN NUMBER,
    p_makhoa IN VARCHAR2
) AS
    v_dem_lop NUMBER := 0;
    v_dem_khoa NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_dem_lop FROM LOP WHERE Tenlop = p_tenlop;
    SELECT COUNT(*) INTO v_dem_khoa FROM KHOA WHERE Makhoa = p_makhoa;

    IF v_dem_lop > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ten lop da ton tai');
    ELSIF v_dem_khoa = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Makhoa khong ton tai trong bang KHOA');
    ELSE
        INSERT INTO LOP VALUES (p_malop, p_tenlop, p_khoa, p_hedt, p_namnhaphoc, p_makhoa);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Them lop thanh cong');
    END IF;
END them_lop;
/
--

SET SERVEROUTPUT ON;
BEGIN
    them_lop('L01', 'Lop CNTT1', 'Nam', 'Chinh quy', 2023, 'CNTT');
END;
/
BEGIN
    them_lop('L02', 'Lop CNTT1', 'Nam', 'Chinh quy', 2023, 'CNTT');
END;
/
BEGIN
    them_lop('L03', 'Lop CNTT3', 'Nam', 'Chinh quy', 2023, 'KT');
END;
/
--
CREATE OR REPLACE PROCEDURE them_khoa_out (
    p_makhoa IN VARCHAR2,
    p_tenkhoa IN VARCHAR2,
    p_dienthoai IN VARCHAR2,
    p_ketqua OUT NUMBER
) AS
    v_dem NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_dem FROM KHOA WHERE Tenkhoa = p_tenkhoa;

    IF v_dem > 0 THEN
        p_ketqua := 0;  -- Đã tồn tại
    ELSE
        INSERT INTO KHOA VALUES (p_makhoa, p_tenkhoa, p_dienthoai);
        COMMIT;
        p_ketqua := 1;  -- Thêm thành công
    END IF;
END them_khoa_out;
/
--
SET SERVEROUTPUT ON;
DECLARE
    v_kq NUMBER;
BEGIN
    them_khoa_out('DTVT', 'Dien tu vien thong', '0111222333', v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq);
END;
/

DECLARE
    v_kq NUMBER;
BEGIN
    them_khoa_out('DTVT2', 'Dien tu vien thong', '0111222333', v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq);
END;
/
--

CREATE OR REPLACE PROCEDURE them_lop_out (
    p_malop IN VARCHAR2,
    p_tenlop IN VARCHAR2,
    p_khoa IN VARCHAR2,
    p_hedt IN VARCHAR2,
    p_namnhaphoc IN NUMBER,
    p_makhoa IN VARCHAR2,
    p_ketqua OUT NUMBER
) AS
    v_dem_lop NUMBER := 0;
    v_dem_khoa NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_dem_lop FROM LOP WHERE Tenlop = p_tenlop;
    SELECT COUNT(*) INTO v_dem_khoa FROM KHOA WHERE Makhoa = p_makhoa;

    IF v_dem_lop > 0 THEN
        p_ketqua := 0;  -- Tên lớp đã tồn tại
    ELSIF v_dem_khoa = 0 THEN
        p_ketqua := 1;  -- Makhoa không tồn tại
    ELSE
        INSERT INTO LOP VALUES (p_malop, p_tenlop, p_khoa, p_hedt, p_namnhaphoc, p_makhoa);
        COMMIT;
        p_ketqua := 2;  -- Thêm thành công
    END IF;
END them_lop_out;
/

--
SET SERVEROUTPUT ON;
DECLARE
    v_kq NUMBER;
BEGIN
    them_lop_out('L04', 'Lop CNTT4', 'Nam', 'Chinh quy', 2024, 'CNTT', v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq);
END;
/
DECLARE
    v_kq NUMBER;
BEGIN
    them_lop_out('L05', 'Lop CNTT4', 'Nam', 'Chinh quy', 2024, 'CNTT', v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq);
END;
/
DECLARE
    v_kq NUMBER;
BEGIN
    them_lop_out('L06', 'Lop CNTT6', 'Nam', 'Chinh quy', 2024, 'XYZ', v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq);
END;
/
