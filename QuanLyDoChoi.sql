-- =============================================
-- KỊCH BẢN TẠO CƠ SỞ DỮ LIỆU CỬA HÀNG ĐỒ CHƠI
-- Dự án: QuanLyDoChoi
-- Bảng CSDL: NguoiDung, SanPham, HoaDon, ChiTietHoaDon
-- =============================================

-- 1. Tạo bảng Người Dùng (NguoiDung)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NguoiDung]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[NguoiDung] (
        [TenDangNhap] VARCHAR(50) NOT NULL PRIMARY KEY,
        [MatKhau] VARCHAR(100) NOT NULL,
        [HoTen] NVARCHAR(100) NOT NULL,
        [Quyen] VARCHAR(20) NOT NULL -- Admin, BanHang, Kho
    );

    INSERT INTO [dbo].[NguoiDung] ([TenDangNhap], [MatKhau], [HoTen], [Quyen]) VALUES
    ('admin', '123456', N'Quản Trị Viên System', 'Admin'),
    ('banhang', '123456', N'Nhân Viên Bán Hàng A', 'BanHang'),
    ('kho', '123456', N'Thủ Kho B', 'Kho');
END
GO

-- 2. Tạo bảng Sản Phẩm Đồ Chơi (SanPham)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SanPham]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[SanPham] (
        [MaSP] INT IDENTITY(1,1) PRIMARY KEY,
        [TenSP] NVARCHAR(150) NOT NULL,
        [Loai] NVARCHAR(50) NOT NULL,
        [Gia] DECIMAL(18,0) NOT NULL,
        [SoLuongTon] INT NOT NULL,
        [HinhAnh] VARCHAR(255) NULL
    );

    INSERT INTO [dbo].[SanPham] ([TenSP], [Loai], [Gia], [SoLuongTon], [HinhAnh]) VALUES
    (N'Mô Hình Gundam RX-78-2 HG 1/144', N'Mô hình', 450000, 15, 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=400'),
    (N'Bộ Lắp Ráp Lego City Cảnh Sát Trượt Xe', N'Lego', 890000, 20, 'https://images.unsplash.com/photo-1585366119957-e9730b6d0f60?w=400'),
    (N'Búp Bê Barbie Công Chúa Thời Trang', N'Búp bê', 320000, 8, 'https://images.unsplash.com/photo-1566576721346-d4a3b4eaeb55?w=400'),
    (N'Xe Đua Hot Wheels Siêu Tốc Độ Pack 5', N'Xe mô hình', 250000, 30, 'https://images.unsplash.com/photo-1594787318286-3d835c1d207f?w=400'),
    (N'Mô Hình Robot Transformer Optimus Prime', N'Mô hình', 1200000, 4, 'https://images.unsplash.com/photo-1563089145-599997674d42?w=400'),
    (N'Bộ Đồ Chơi Cát Động Học Kèm Khuôn Tròn', N'Đồ chơi giáo dục', 150000, 25, 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=400');
END
GO

-- 3. Tạo bảng Hóa Đơn (HoaDon)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HoaDon]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[HoaDon] (
        [MaHD] INT IDENTITY(1001,1) PRIMARY KEY,
        [NgayTao] DATETIME DEFAULT GETDATE(),
        [NguoiTao] VARCHAR(50) NOT NULL,
        [TongTien] DECIMAL(18,0) NOT NULL
    );
END
GO

-- 4. Tạo bảng Chi Tiết Hóa Đơn (ChiTietHoaDon) & Chèn dữ liệu hóa đơn mẫu
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChiTietHoaDon]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[ChiTietHoaDon] (
        [MaCT] INT IDENTITY(1,1) PRIMARY KEY,
        [MaHD] INT NOT NULL FOREIGN KEY REFERENCES [dbo].[HoaDon](MaHD) ON DELETE CASCADE,
        [MaSP] INT NOT NULL,
        [TenSP] NVARCHAR(150) NOT NULL,
        [SoLuong] INT NOT NULL,
        [DonGia] DECIMAL(18,0) NOT NULL,
        [ThanhTien] DECIMAL(18,0) NOT NULL
    );

    INSERT INTO [dbo].[HoaDon] ([NgayTao], [NguoiTao], [TongTien]) VALUES (GETDATE(), 'banhang', 770000);
    DECLARE @SampleHD INT = SCOPE_IDENTITY();
    INSERT INTO [dbo].[ChiTietHoaDon] ([MaHD], [MaSP], [TenSP], [SoLuong], [DonGia], [ThanhTien]) VALUES
    (@SampleHD, 1, N'Mô Hình Gundam RX-78-2 HG 1/144', 1, 450000, 450000),
    (@SampleHD, 3, N'Búp Bê Barbie Công Chúa Thời Trang', 1, 320000, 320000);
END
GO
