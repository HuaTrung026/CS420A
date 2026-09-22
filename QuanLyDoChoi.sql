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
    (N'Mô Hình Gundam RX-78-2 HG 1/144', N'Mô hình', 450000, 15, 'https://images.unsplash.com/photo-1589254065878-42c9da997008?w=500&auto=format&fit=crop&q=80'),
    (N'Bộ Lắp Ráp Lego City Cảnh Sát Đuổi Bắt', N'Lego', 890000, 20, 'https://images.unsplash.com/photo-1585366119957-e9730b6d0f60?w=500&auto=format&fit=crop&q=80'),
    (N'Búp Bê Barbie Thời Trang Dạ Hội', N'Búp bê', 320000, 8, 'https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?w=500&auto=format&fit=crop&q=80'),
    (N'Hộp 5 Xe Đua Hot Wheels Siêu Tốc', N'Xe mô hình', 250000, 30, 'https://images.unsplash.com/photo-1594787318286-3d835c1d207f?w=500&auto=format&fit=crop&q=80'),
    (N'Mô Hình Robot Biến Hình Transformers', N'Mô hình', 1200000, 4, 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=500&auto=format&fit=crop&q=80'),
    (N'Hộp Boardgame Cờ Tỷ Phú Cao Cấp', N'Boardgame', 180000, 25, 'https://images.unsplash.com/photo-1610890716171-6b1bb98ffd09?w=500&auto=format&fit=crop&q=80');
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
