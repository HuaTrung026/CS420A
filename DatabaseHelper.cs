using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;

namespace QuanLyDoChoi
{
    public class NguoiDung
    {
        public string TenDangNhap { get; set; }
        public string MatKhau { get; set; }
        public string HoTen { get; set; }
        public string Quyen { get; set; }
    }

    public class SanPham
    {
        public int MaSP { get; set; }
        public string TenSP { get; set; }
        public string Loai { get; set; }
        public decimal Gia { get; set; }
        public int SoLuongTon { get; set; }
        public string HinhAnh { get; set; }
    }

    public class HoaDonModel
    {
        public int MaHD { get; set; }
        public DateTime NgayTao { get; set; }
        public string NguoiTao { get; set; }
        public decimal TongTien { get; set; }
        public List<ChiTietHoaDonModel> ChiTiet { get; set; }

        public HoaDonModel()
        {
            ChiTiet = new List<ChiTietHoaDonModel>();
        }
    }

    public class ChiTietHoaDonModel
    {
        public int MaCT { get; set; }
        public int MaHD { get; set; }
        public int MaSP { get; set; }
        public string TenSP { get; set; }
        public int SoLuong { get; set; }
        public decimal DonGia { get; set; }
        public decimal ThanhTien { get; set; }
    }

    public static class DatabaseHelper
    {
        private static readonly string primaryConnStr;
        private static bool isInitialized = false;

        private static readonly List<NguoiDung> mockUsers = new List<NguoiDung>();
        private static readonly List<SanPham> mockProducts = new List<SanPham>();
        private static readonly List<HoaDonModel> mockInvoices = new List<HoaDonModel>();
        private static bool useInMemoryFallback = false;

        static DatabaseHelper()
        {
            try
            {
                var connObj = ConfigurationManager.ConnectionStrings["QuanLyDoChoiConnectionString"];
                primaryConnStr = connObj != null ? connObj.ConnectionString : @"Data Source=(LocalDB)\MSSQLLocalDB;Initial Catalog=QuanLyDoChoiDB;Integrated Security=True;";
            }
            catch
            {
                primaryConnStr = @"Data Source=(LocalDB)\MSSQLLocalDB;Initial Catalog=QuanLyDoChoiDB;Integrated Security=True;";
            }

            InitMockData();
        }

        private static void InitMockData()
        {
            mockUsers.Clear();
            mockUsers.Add(new NguoiDung { TenDangNhap = "admin", MatKhau = "123456", HoTen = "Quản Trị Viên System", Quyen = "Admin" });
            mockUsers.Add(new NguoiDung { TenDangNhap = "banhang", MatKhau = "123456", HoTen = "Nhân Viên Bán Hàng A", Quyen = "BanHang" });
            mockUsers.Add(new NguoiDung { TenDangNhap = "kho", MatKhau = "123456", HoTen = "Thủ Kho B", Quyen = "Kho" });

            mockProducts.Clear();
            mockProducts.Add(new SanPham { MaSP = 1, TenSP = "Mô Hình Gundam RX-78-2 HG 1/144", Loai = "Mô hình", Gia = 450000, SoLuongTon = 15, HinhAnh = "https://images.unsplash.com/photo-1589254065878-42c9da997008?w=500&auto=format&fit=crop&q=80" });
            mockProducts.Add(new SanPham { MaSP = 2, TenSP = "Bộ Lắp Ráp Lego City Cảnh Sát Đuổi Bắt", Loai = "Lego", Gia = 890000, SoLuongTon = 20, HinhAnh = "https://images.unsplash.com/photo-1585366119957-e9730b6d0f60?w=500&auto=format&fit=crop&q=80" });
            mockProducts.Add(new SanPham { MaSP = 3, TenSP = "Búp Bê Barbie Thời Trang Dạ Hội", Loai = "Búp bê", Gia = 320000, SoLuongTon = 8, HinhAnh = "https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?w=500&auto=format&fit=crop&q=80" });
            mockProducts.Add(new SanPham { MaSP = 4, TenSP = "Hộp 5 Xe Đua Hot Wheels Siêu Tốc", Loai = "Xe mô hình", Gia = 250000, SoLuongTon = 30, HinhAnh = "https://images.unsplash.com/photo-1594787318286-3d835c1d207f?w=500&auto=format&fit=crop&q=80" });
            mockProducts.Add(new SanPham { MaSP = 5, TenSP = "Mô Hình Robot Biến Hình Transformers", Loai = "Mô hình", Gia = 1200000, SoLuongTon = 4, HinhAnh = "https://images.unsplash.com/photo-1534447677768-be436bb09401?w=500&auto=format&fit=crop&q=80" });
            mockProducts.Add(new SanPham { MaSP = 6, TenSP = "Hộp Boardgame Cờ Tỷ Phú Cao Cấp", Loai = "Boardgame", Gia = 180000, SoLuongTon = 25, HinhAnh = "https://images.unsplash.com/photo-1610890716171-6b1bb98ffd09?w=500&auto=format&fit=crop&q=80" });

            mockInvoices.Clear();
            List<ChiTietHoaDonModel> sampleItems = new List<ChiTietHoaDonModel>();
            sampleItems.Add(new ChiTietHoaDonModel { MaCT = 1, MaHD = 1001, MaSP = 1, TenSP = "Mô Hình Gundam RX-78-2 HG 1/144", SoLuong = 1, DonGia = 450000, ThanhTien = 450000 });
            sampleItems.Add(new ChiTietHoaDonModel { MaCT = 2, MaHD = 1001, MaSP = 3, TenSP = "Búp Bê Barbie Công Chúa Thời Trang", SoLuong = 1, DonGia = 320000, ThanhTien = 320000 });

            mockInvoices.Add(new HoaDonModel
            {
                MaHD = 1001,
                NgayTao = DateTime.Now.AddHours(-2),
                NguoiTao = "banhang",
                TongTien = 770000,
                ChiTiet = sampleItems
            });
        }

        public static void InitializeDatabase()
        {
            if (isInitialized) return;
            isInitialized = true;

            try
            {
                using (SqlConnection conn = new SqlConnection(primaryConnStr))
                {
                    conn.Open();
                    
                    string createTablesSql = @"
                    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NguoiDung]') AND type in (N'U'))
                    BEGIN
                        CREATE TABLE [dbo].[NguoiDung] (
                            [TenDangNhap] VARCHAR(50) NOT NULL PRIMARY KEY,
                            [MatKhau] VARCHAR(100) NOT NULL,
                            [HoTen] NVARCHAR(100) NOT NULL,
                            [Quyen] VARCHAR(20) NOT NULL
                        );
                        INSERT INTO [dbo].[NguoiDung] VALUES
                        ('admin', '123456', N'Quản Trị Viên System', 'Admin'),
                        ('banhang', '123456', N'Nhân Viên Bán Hàng A', 'BanHang'),
                        ('kho', '123456', N'Thủ Kho B', 'Kho');
                    END;

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
                    END;

                    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HoaDon]') AND type in (N'U'))
                    BEGIN
                        CREATE TABLE [dbo].[HoaDon] (
                            [MaHD] INT IDENTITY(1001,1) PRIMARY KEY,
                            [NgayTao] DATETIME DEFAULT GETDATE(),
                            [NguoiTao] VARCHAR(50) NOT NULL,
                            [TongTien] DECIMAL(18,0) NOT NULL
                        );
                    END;

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
                    END;
                    ";

                    using (SqlCommand cmd = new SqlCommand(createTablesSql, conn))
                    {
                        cmd.ExecuteNonQuery();
                    }
                }
                useInMemoryFallback = false;
            }
            catch
            {
                useInMemoryFallback = true;
            }
        }

        public static NguoiDung DangNhap(string username, string password)
        {
            InitializeDatabase();
            if (useInMemoryFallback)
            {
                return mockUsers.Find(u => u.TenDangNhap.Equals(username, StringComparison.OrdinalIgnoreCase) && u.MatKhau == password);
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(primaryConnStr))
                {
                    conn.Open();
                    string sql = "SELECT TenDangNhap, MatKhau, HoTen, Quyen FROM NguoiDung WHERE TenDangNhap = @u AND MatKhau = @p";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@u", username ?? "");
                        cmd.Parameters.AddWithValue("@p", password ?? "");
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                return new NguoiDung
                                {
                                    TenDangNhap = dr["TenDangNhap"].ToString(),
                                    MatKhau = dr["MatKhau"].ToString(),
                                    HoTen = dr["HoTen"].ToString(),
                                    Quyen = dr["Quyen"].ToString()
                                };
                            }
                        }
                    }
                }
            }
            catch
            {
                return mockUsers.Find(u => u.TenDangNhap.Equals(username, StringComparison.OrdinalIgnoreCase) && u.MatKhau == password);
            }
            return null;
        }

        public static List<SanPham> GetDanhSachSanPham(string kw = "")
        {
            InitializeDatabase();
            if (useInMemoryFallback)
            {
                if (string.IsNullOrWhiteSpace(kw)) return new List<SanPham>(mockProducts);
                return mockProducts.FindAll(p => p.TenSP.ToLower().Contains(kw.ToLower()) || p.Loai.ToLower().Contains(kw.ToLower()));
            }

            List<SanPham> list = new List<SanPham>();
            try
            {
                using (SqlConnection conn = new SqlConnection(primaryConnStr))
                {
                    conn.Open();
                    string sql = "SELECT MaSP, TenSP, Loai, Gia, SoLuongTon, HinhAnh FROM SanPham WHERE @kw = '' OR TenSP LIKE @searchKw OR Loai LIKE @searchKw ORDER BY MaSP DESC";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@kw", kw ?? "");
                        cmd.Parameters.AddWithValue("@searchKw", "%" + (kw ?? "") + "%");
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                list.Add(new SanPham
                                {
                                    MaSP = Convert.ToInt32(dr["MaSP"]),
                                    TenSP = dr["TenSP"].ToString(),
                                    Loai = dr["Loai"].ToString(),
                                    Gia = Convert.ToDecimal(dr["Gia"]),
                                    SoLuongTon = Convert.ToInt32(dr["SoLuongTon"]),
                                    HinhAnh = dr["HinhAnh"] != DBNull.Value ? dr["HinhAnh"].ToString() : ""
                                });
                            }
                        }
                    }
                }
            }
            catch
            {
                if (string.IsNullOrWhiteSpace(kw)) return new List<SanPham>(mockProducts);
                return mockProducts.FindAll(p => p.TenSP.ToLower().Contains(kw.ToLower()) || p.Loai.ToLower().Contains(kw.ToLower()));
            }
            return list;
        }

        public static bool ThemSanPham(string tenSP, string loai, decimal gia, int soLuongTon, string hinhAnh)
        {
            InitializeDatabase();
            if (useInMemoryFallback)
            {
                int newId = mockProducts.Count > 0 ? mockProducts[mockProducts.Count - 1].MaSP + 1 : 1;
                mockProducts.Add(new SanPham
                {
                    MaSP = newId,
                    TenSP = tenSP,
                    Loai = loai,
                    Gia = gia,
                    SoLuongTon = soLuongTon,
                    HinhAnh = string.IsNullOrWhiteSpace(hinhAnh) ? "https://images.unsplash.com/photo-1533230393618-0c74ed0dc23e?w=400" : hinhAnh
                });
                return true;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(primaryConnStr))
                {
                    conn.Open();
                    string sql = "INSERT INTO SanPham (TenSP, Loai, Gia, SoLuongTon, HinhAnh) VALUES (@ten, @loai, @gia, @sl, @img)";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@ten", tenSP);
                        cmd.Parameters.AddWithValue("@loai", loai);
                        cmd.Parameters.AddWithValue("@gia", gia);
                        cmd.Parameters.AddWithValue("@sl", soLuongTon);
                        cmd.Parameters.AddWithValue("@img", string.IsNullOrWhiteSpace(hinhAnh) ? "https://images.unsplash.com/photo-1533230393618-0c74ed0dc23e?w=400" : hinhAnh);
                        return cmd.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch
            {
                int newId = mockProducts.Count > 0 ? mockProducts[mockProducts.Count - 1].MaSP + 1 : 1;
                mockProducts.Add(new SanPham
                {
                    MaSP = newId,
                    TenSP = tenSP,
                    Loai = loai,
                    Gia = gia,
                    SoLuongTon = soLuongTon,
                    HinhAnh = string.IsNullOrWhiteSpace(hinhAnh) ? "https://images.unsplash.com/photo-1533230393618-0c74ed0dc23e?w=400" : hinhAnh
                });
                return true;
            }
        }

        public static bool NhapThemKho(int maSP, int soLuongNhap)
        {
            InitializeDatabase();
            if (useInMemoryFallback)
            {
                var p = mockProducts.Find(x => x.MaSP == maSP);
                if (p != null)
                {
                    p.SoLuongTon += soLuongNhap;
                    return true;
                }
                return false;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(primaryConnStr))
                {
                    conn.Open();
                    string sql = "UPDATE SanPham SET SoLuongTon = SoLuongTon + @sl WHERE MaSP = @ma";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@sl", soLuongNhap);
                        cmd.Parameters.AddWithValue("@ma", maSP);
                        return cmd.ExecuteNonQuery() > 0;
                    }
                }
            }
            catch
            {
                var p = mockProducts.Find(x => x.MaSP == maSP);
                if (p != null)
                {
                    p.SoLuongTon += soLuongNhap;
                    return true;
                }
                return false;
            }
        }

        public static int ThanhToanHoaDon(string nguoiTao, List<ChiTietHoaDonModel> items, out string errorMsg)
        {
            errorMsg = "";
            InitializeDatabase();
            if (items == null || items.Count == 0)
            {
                errorMsg = "Giỏ hàng đang trống!";
                return 0;
            }

            decimal tongTien = 0;
            foreach (var item in items)
            {
                item.ThanhTien = item.SoLuong * item.DonGia;
                tongTien += item.ThanhTien;
            }

            if (useInMemoryFallback)
            {
                foreach (var item in items)
                {
                    var p = mockProducts.Find(x => x.MaSP == item.MaSP);
                    if (p == null || p.SoLuongTon < item.SoLuong)
                    {
                        errorMsg = string.Format("Sản phẩm '{0}' không đủ số lượng tồn kho (Còn lại: {1})", item.TenSP, p != null ? p.SoLuongTon : 0);
                        return 0;
                    }
                }

                foreach (var item in items)
                {
                    var p = mockProducts.Find(x => x.MaSP == item.MaSP);
                    p.SoLuongTon -= item.SoLuong;
                }

                int newMaHD = mockInvoices.Count > 0 ? mockInvoices[mockInvoices.Count - 1].MaHD + 1 : 1001;
                HoaDonModel hd = new HoaDonModel
                {
                    MaHD = newMaHD,
                    NgayTao = DateTime.Now,
                    NguoiTao = nguoiTao,
                    TongTien = tongTien,
                    ChiTiet = new List<ChiTietHoaDonModel>(items)
                };
                mockInvoices.Insert(0, hd);
                return newMaHD;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(primaryConnStr))
                {
                    conn.Open();
                    using (SqlTransaction tran = conn.BeginTransaction())
                    {
                        try
                        {
                            foreach (var item in items)
                            {
                                string checkSql = "SELECT SoLuongTon, TenSP FROM SanPham WHERE MaSP = @ma";
                                using (SqlCommand checkCmd = new SqlCommand(checkSql, conn, tran))
                                {
                                    checkCmd.Parameters.AddWithValue("@ma", item.MaSP);
                                    using (SqlDataReader dr = checkCmd.ExecuteReader())
                                    {
                                        if (dr.Read())
                                        {
                                            int ton = Convert.ToInt32(dr["SoLuongTon"]);
                                            if (ton < item.SoLuong)
                                            {
                                                errorMsg = string.Format("Sản phẩm '{0}' chỉ còn tồn {1}, không đủ bán {2}!", dr["TenSP"], ton, item.SoLuong);
                                                dr.Close();
                                                tran.Rollback();
                                                return 0;
                                            }
                                        }
                                        else
                                        {
                                            errorMsg = string.Format("Sản phẩm mã #{0} không tồn tại!", item.MaSP);
                                            dr.Close();
                                            tran.Rollback();
                                            return 0;
                                        }
                                    }
                                }
                            }

                            int newMaHD = 0;
                            string insertHdSql = "INSERT INTO HoaDon (NgayTao, NguoiTao, TongTien) OUTPUT INSERTED.MaHD VALUES (GETDATE(), @user, @tong)";
                            using (SqlCommand cmdHd = new SqlCommand(insertHdSql, conn, tran))
                            {
                                cmdHd.Parameters.AddWithValue("@user", nguoiTao);
                                cmdHd.Parameters.AddWithValue("@tong", tongTien);
                                newMaHD = Convert.ToInt32(cmdHd.ExecuteScalar());
                            }

                            foreach (var item in items)
                            {
                                string insertCtSql = "INSERT INTO ChiTietHoaDon (MaHD, MaSP, TenSP, SoLuong, DonGia, ThanhTien) VALUES (@hd, @sp, @ten, @sl, @gia, @tt)";
                                using (SqlCommand cmdCt = new SqlCommand(insertCtSql, conn, tran))
                                {
                                    cmdCt.Parameters.AddWithValue("@hd", newMaHD);
                                    cmdCt.Parameters.AddWithValue("@sp", item.MaSP);
                                    cmdCt.Parameters.AddWithValue("@ten", item.TenSP);
                                    cmdCt.Parameters.AddWithValue("@sl", item.SoLuong);
                                    cmdCt.Parameters.AddWithValue("@gia", item.DonGia);
                                    cmdCt.Parameters.AddWithValue("@tt", item.ThanhTien);
                                    cmdCt.ExecuteNonQuery();
                                }

                                string updateStockSql = "UPDATE SanPham SET SoLuongTon = SoLuongTon - @sl WHERE MaSP = @sp";
                                using (SqlCommand cmdStock = new SqlCommand(updateStockSql, conn, tran))
                                {
                                    cmdStock.Parameters.AddWithValue("@sl", item.SoLuong);
                                    cmdStock.Parameters.AddWithValue("@sp", item.MaSP);
                                    cmdStock.ExecuteNonQuery();
                                }
                            }

                            tran.Commit();
                            return newMaHD;
                        }
                        catch (Exception ex)
                        {
                            tran.Rollback();
                            errorMsg = "Lỗi khi lưu hóa đơn: " + ex.Message;
                            return 0;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                foreach (var item in items)
                {
                    var p = mockProducts.Find(x => x.MaSP == item.MaSP);
                    if (p != null) p.SoLuongTon -= item.SoLuong;
                }
                int newMaHD = mockInvoices.Count > 0 ? mockInvoices[mockInvoices.Count - 1].MaHD + 1 : 1001;
                mockInvoices.Insert(0, new HoaDonModel
                {
                    MaHD = newMaHD,
                    NgayTao = DateTime.Now,
                    NguoiTao = nguoiTao,
                    TongTien = tongTien,
                    ChiTiet = new List<ChiTietHoaDonModel>(items)
                });
                return newMaHD;
            }
        }

        public static List<HoaDonModel> GetDanhSachHoaDon()
        {
            InitializeDatabase();
            if (useInMemoryFallback)
            {
                return new List<HoaDonModel>(mockInvoices);
            }

            List<HoaDonModel> list = new List<HoaDonModel>();
            try
            {
                using (SqlConnection conn = new SqlConnection(primaryConnStr))
                {
                    conn.Open();
                    string sql = "SELECT MaHD, NgayTao, NguoiTao, TongTien FROM HoaDon ORDER BY MaHD DESC";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                list.Add(new HoaDonModel
                                {
                                    MaHD = Convert.ToInt32(dr["MaHD"]),
                                    NgayTao = Convert.ToDateTime(dr["NgayTao"]),
                                    NguoiTao = dr["NguoiTao"].ToString(),
                                    TongTien = Convert.ToDecimal(dr["TongTien"])
                                });
                            }
                        }
                    }

                    foreach (var hd in list)
                    {
                        string ctSql = "SELECT MaCT, MaHD, MaSP, TenSP, SoLuong, DonGia, ThanhTien FROM ChiTietHoaDon WHERE MaHD = @hd";
                        using (SqlCommand ctCmd = new SqlCommand(ctSql, conn))
                        {
                            ctCmd.Parameters.AddWithValue("@hd", hd.MaHD);
                            using (SqlDataReader drCt = ctCmd.ExecuteReader())
                            {
                                while (drCt.Read())
                                {
                                    hd.ChiTiet.Add(new ChiTietHoaDonModel
                                    {
                                        MaCT = Convert.ToInt32(drCt["MaCT"]),
                                        MaHD = Convert.ToInt32(drCt["MaHD"]),
                                        MaSP = Convert.ToInt32(drCt["MaSP"]),
                                        TenSP = drCt["TenSP"].ToString(),
                                        SoLuong = Convert.ToInt32(drCt["SoLuong"]),
                                        DonGia = Convert.ToDecimal(drCt["DonGia"]),
                                        ThanhTien = Convert.ToDecimal(drCt["ThanhTien"])
                                    });
                                }
                            }
                        }
                    }
                }
            }
            catch
            {
                return new List<HoaDonModel>(mockInvoices);
            }
            return list;
        }
    }
}
