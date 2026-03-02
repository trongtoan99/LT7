CREATE TABLE tblChucVu (
    MaCV VARCHAR2(10) PRIMARY KEY,
    TenCV VARCHAR2(100)
);

CREATE TABLE tblNhanVien (
    MaNV VARCHAR2(10) PRIMARY KEY,
    MaCV VARCHAR2(10),
    TenNV VARCHAR2(100),
    NgaySinh DATE,
    LuongCanBan NUMBER(10,2),
    NgayCong NUMBER(2),
    PhuCap NUMBER(10,2),
    FOREIGN KEY (MaCV) REFERENCES tblChucVu(MaCV)
);
--
INSERT INTO tblChucVu VALUES ('CV01', 'Giam doc');
INSERT INTO tblChucVu VALUES ('CV02', 'Truong phong');
INSERT INTO tblChucVu VALUES ('CV03', 'Nhan vien');
INSERT INTO tblChucVu VALUES ('CV04', 'Ke toan');
COMMIT;

INSERT INTO tblNhanVien VALUES ('NV01', 'CV01', 'Nguyen Van A', TO_DATE('15/06/1990', 'DD/MM/YYYY'), 10000000, 26, 500000);
INSERT INTO tblNhanVien VALUES ('NV02', 'CV02', 'Tran Thi B', TO_DATE('20/08/1995', 'DD/MM/YYYY'), 7000000, 24, 300000);
INSERT INTO tblNhanVien VALUES ('NV03', 'CV03', 'Le Van C', TO_DATE('10/01/1998', 'DD/MM/YYYY'), 5000000, 22, 200000);
COMMIT;
--
CREATE OR REPLACE PROCEDURE SP_Them_Nhan_Vien (
    MaNV IN VARCHAR2,
    MaCV IN VARCHAR2,
    TenNV IN VARCHAR2,
    NgaySinh IN DATE,
    LuongCanBan IN NUMBER,
    NgayCong IN NUMBER,
    PhuCap IN NUMBER
) AS
    v_dem NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_dem FROM tblChucVu WHERE tblChucVu.MaCV = SP_Them_Nhan_Vien.MaCV;

    IF v_dem = 0 THEN
        DBMS_OUTPUT.PUT_LINE('MaCV khong ton tai!');
    ELSE
        INSERT INTO tblNhanVien VALUES (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Them nhan vien thanh cong!');
    END IF;
END SP_Them_Nhan_Vien;
/
--
SET SERVEROUTPUT ON;
BEGIN
    SP_Them_Nhan_Vien('NV04', 'CV03', 'Pham Thi D', TO_DATE('05/03/2000', 'DD/MM/YYYY'), 5000000, 20, 100000);
END;
/
BEGIN
    SP_Them_Nhan_Vien('NV05', 'CV99', 'Hoang Van E', TO_DATE('01/01/1999', 'DD/MM/YYYY'), 5000000, 20, 100000);
END;
/
--
CREATE OR REPLACE PROCEDURE SP_CapNhat_Nhan_Vien (
    MaNV IN VARCHAR2,
    MaCV IN VARCHAR2,
    TenNV IN VARCHAR2,
    NgaySinh IN DATE,
    LuongCanBan IN NUMBER,
    NgayCong IN NUMBER,
    PhuCap IN NUMBER
) AS
    v_dem NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_dem FROM tblChucVu WHERE tblChucVu.MaCV = SP_CapNhat_Nhan_Vien.MaCV;

    IF v_dem = 0 THEN
        DBMS_OUTPUT.PUT_LINE('MaCV khong ton tai!');
    ELSE
        UPDATE tblNhanVien SET
            tblNhanVien.MaCV = SP_CapNhat_Nhan_Vien.MaCV,
            TenNV = SP_CapNhat_Nhan_Vien.TenNV,
            NgaySinh = SP_CapNhat_Nhan_Vien.NgaySinh,
            LuongCanBan = SP_CapNhat_Nhan_Vien.LuongCanBan,
            NgayCong = SP_CapNhat_Nhan_Vien.NgayCong,
            PhuCap = SP_CapNhat_Nhan_Vien.PhuCap
        WHERE tblNhanVien.MaNV = SP_CapNhat_Nhan_Vien.MaNV;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Cap nhat thanh cong!');
    END IF;
END SP_CapNhat_Nhan_Vien;
/
--
SET SERVEROUTPUT ON;
BEGIN
    SP_CapNhat_Nhan_Vien('NV01', 'CV02', 'Nguyen Van A (sua)', TO_DATE('15/06/1990', 'DD/MM/YYYY'), 12000000, 26, 600000);
END;
/
BEGIN
    SP_CapNhat_Nhan_Vien('NV01', 'CV99', 'Nguyen Van A', TO_DATE('15/06/1990', 'DD/MM/YYYY'), 12000000, 26, 600000);
END;
/
--
CREATE OR REPLACE PROCEDURE SP_LuongLN AS
    v_manv tblNhanVien.MaNV%TYPE;
    v_tennv tblNhanVien.TenNV%TYPE;
    v_luong NUMBER;
BEGIN
    FOR r IN (SELECT MaNV, TenNV, LuongCanBan, NgayCong, PhuCap FROM tblNhanVien) LOOP
        v_luong := r.LuongCanBan * r.NgayCong + r.PhuCap;
        DBMS_OUTPUT.PUT_LINE('NV: ' || r.TenNV || ' - Luong: ' || v_luong);
    END LOOP;
END SP_LuongLN;
/
--
SET SERVEROUTPUT ON;

BEGIN
    SP_LuongLN;
END;
/

--
CREATE OR REPLACE PROCEDURE sp_them_nhan_vien1 (
    MaNV IN VARCHAR2,
    MaCV IN VARCHAR2,
    TenNV IN VARCHAR2,
    NgaySinh IN DATE,
    LuongCB IN NUMBER,
    NgayCong IN NUMBER,
    PhuCap IN NUMBER,
    p_ketqua OUT NUMBER
) AS
    v_dem NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_dem FROM tblChucVu WHERE tblChucVu.MaCV = sp_them_nhan_vien1.MaCV;

    IF v_dem = 0 THEN
        p_ketqua := 0; 
    ELSE
        INSERT INTO tblNhanVien VALUES (MaNV, MaCV, TenNV, NgaySinh, LuongCB, NgayCong, PhuCap);
        COMMIT;
        p_ketqua := 1;  
    END IF;
END sp_them_nhan_vien1;
/

--
SET SERVEROUTPUT ON;
DECLARE
    v_kq NUMBER;
BEGIN
    sp_them_nhan_vien1('NV05', 'CV03', 'Hoang Van E', TO_DATE('01/01/1999', 'DD/MM/YYYY'), 5000000, 20, 100000, v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq);
END;
/
DECLARE
    v_kq NUMBER;
BEGIN
    sp_them_nhan_vien1('NV06', 'CV99', 'Nguyen Thi F', TO_DATE('05/05/2000', 'DD/MM/YYYY'), 5000000, 20, 100000, v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq);
END;
/
--
CREATE OR REPLACE PROCEDURE sp_them_nhan_vien2 (
    MaNV IN VARCHAR2,
    MaCV IN VARCHAR2,
    TenNV IN VARCHAR2,
    NgaySinh IN DATE,
    LuongCB IN NUMBER,
    NgayCong IN NUMBER,
    PhuCap IN NUMBER,
    p_ketqua OUT NUMBER
) AS
    v_dem_nv NUMBER := 0;
    v_dem_cv NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_dem_nv FROM tblNhanVien WHERE tblNhanVien.MaNV = sp_them_nhan_vien2.MaNV;
    SELECT COUNT(*) INTO v_dem_cv FROM tblChucVu WHERE tblChucVu.MaCV = sp_them_nhan_vien2.MaCV;

    IF v_dem_nv > 0 THEN
        p_ketqua := 0;  
    ELSIF v_dem_cv = 0 THEN
        p_ketqua := 1;  
    ELSE
        INSERT INTO tblNhanVien VALUES (MaNV, MaCV, TenNV, NgaySinh, LuongCB, NgayCong, PhuCap);
        COMMIT;
        p_ketqua := 2; 
    END IF;
END sp_them_nhan_vien2;
/
--
SET SERVEROUTPUT ON;

DECLARE
    v_kq NUMBER;
BEGIN
    sp_them_nhan_vien2('NV07', 'CV04', 'Tran Van G', TO_DATE('10/10/1997', 'DD/MM/YYYY'), 6000000, 23, 200000, v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq);
END;
/

DECLARE
    v_kq NUMBER;
BEGIN
    sp_them_nhan_vien2('NV01', 'CV04', 'Tran Van G', TO_DATE('10/10/1997', 'DD/MM/YYYY'), 6000000, 23, 200000, v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq);
END;
/

DECLARE
    v_kq NUMBER;
BEGIN
    sp_them_nhan_vien2('NV08', 'CV99', 'Le Thi H', TO_DATE('20/07/1996', 'DD/MM/YYYY'), 6000000, 23, 200000, v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq);
END;
/

--
CREATE OR REPLACE PROCEDURE sp_capnhat_ngaysinh (
    MaNV IN VARCHAR2,
    NgaySinh IN DATE,
    p_ketqua OUT NUMBER
) AS
    v_dem NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_dem FROM tblNhanVien WHERE tblNhanVien.MaNV = sp_capnhat_ngaysinh.MaNV;

    IF v_dem = 0 THEN
        p_ketqua := 0;  
    ELSE
        UPDATE tblNhanVien SET
            tblNhanVien.NgaySinh = sp_capnhat_ngaysinh.NgaySinh
        WHERE tblNhanVien.MaNV = sp_capnhat_ngaysinh.MaNV;
        COMMIT;
        p_ketqua := 1;  
    END IF;
END sp_capnhat_ngaysinh;
/
--
SET SERVEROUTPUT ON;
DECLARE
    v_kq NUMBER;
BEGIN
    sp_capnhat_ngaysinh('NV01', TO_DATE('20/06/1990', 'DD/MM/YYYY'), v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq);
END;
/
DECLARE
    v_kq NUMBER;
BEGIN
    sp_capnhat_ngaysinh('NV99', TO_DATE('20/06/1990', 'DD/MM/YYYY'), v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq);
END;
/