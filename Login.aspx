<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="QuanLyDoChoi.Login" %>

<!DOCTYPE html>
<html lang="vi">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng Nhập - Quản Lý Cửa Hàng Đồ Chơi</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet" />

    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #e9ecef;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .card-login {
            max-width: 420px;
            width: 100%;
            border: 1px solid #ced4da;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="card card-login bg-white rounded-3">
            <div class="card-header bg-primary text-white text-center py-3">
                <h4 class="mb-0 fw-bold"><i class="bi bi-box-seam me-2"></i>QUẢN LÝ ĐỒ CHƠI</h4>
                <small>Đăng nhập hệ thống</small>
            </div>

            <div class="card-body p-4">
                <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger py-2 px-3 small">
                    <asp:Literal ID="lblError" runat="server"></asp:Literal>
                </asp:Panel>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Tên đăng nhập:</label>
                    <asp:TextBox ID="txtTenDangNhap" runat="server" CssClass="form-control" placeholder="Nhập tên đăng nhập..."></asp:TextBox>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-semibold">Mật khẩu:</label>
                    <asp:TextBox ID="txtMatKhau" runat="server" TextMode="Password" CssClass="form-control" placeholder="Nhập mật khẩu..."></asp:TextBox>
                </div>

                <asp:Button ID="btnDangNhap" runat="server" Text="Đăng Nhập" OnClick="btnDangNhap_Click" CssClass="btn btn-primary w-100 fw-bold py-2 mb-3" />

                <!-- Chọn tài khoản demo -->
                <div class="border-top pt-3 text-center">
                    <label class="form-label small text-muted d-block mb-2">Đăng nhập nhanh tài khoản mẫu:</label>
                    <div class="btn-group w-100" role="group">
                        <asp:Button ID="btnDemoAdmin" runat="server" Text="Admin" OnClick="btnDemoAdmin_Click" CssClass="btn btn-outline-danger btn-sm" UseSubmitBehavior="false" />
                        <asp:Button ID="btnDemoBanHang" runat="server" Text="Bán Hàng" OnClick="btnDemoBanHang_Click" CssClass="btn btn-outline-success btn-sm" UseSubmitBehavior="false" />
                        <asp:Button ID="btnDemoKho" runat="server" Text="Thủ Kho" OnClick="btnDemoKho_Click" CssClass="btn btn-outline-warning btn-sm text-dark" UseSubmitBehavior="false" />
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
