<%@ Page Title="Quản Lý Kho" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="QuanLyKho.aspx.cs" Inherits="QuanLyDoChoi.QuanLyKho" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h4 class="fw-bold text-primary mb-1"><i class="bi bi-box-seam me-1"></i> Quản Lý Tồn Kho & Nhập Hàng</h4>
            <p class="text-muted small mb-0">Xem danh sách tồn kho, thêm sản phẩm đồ chơi và cập nhật số lượng nhập kho</p>
        </div>
        <div>
            <button type="button" class="btn btn-primary btn-sm fw-bold" data-bs-toggle="modal" data-bs-target="#modalThemSP">
                <i class="bi bi-plus-circle me-1"></i> Thêm Sản Phẩm Mới
            </button>
        </div>
    </div>

    <!-- Alert Thông báo -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show mb-3" role="alert">
        <asp:Literal ID="lblAlertMsg" runat="server"></asp:Literal>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </asp:Panel>

    <!-- Thống kê tồn kho nhanh (Cân đối khoảng trắng) -->
    <div class="row g-3 mb-3">
        <div class="col-md-4">
            <div class="card p-3 bg-white border shadow-sm">
                <div class="d-flex align-items-center">
                    <div class="p-3 bg-primary-subtle text-primary rounded-3 me-3">
                        <i class="bi bi-boxes fs-4"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Tổng số mặt hàng</div>
                        <h5 class="fw-bold mb-0 text-dark"><asp:Literal ID="lblTongMatHang" runat="server">0</asp:Literal> sản phẩm</h5>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-3 bg-white border shadow-sm">
                <div class="d-flex align-items-center">
                    <div class="p-3 bg-warning-subtle text-danger rounded-3 me-3">
                        <i class="bi bi-exclamation-triangle fs-4"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Mặt hàng cảnh báo sắp hết (&lt; 5)</div>
                        <h5 class="fw-bold mb-0 text-danger"><asp:Literal ID="lblCanhBao" runat="server">0</asp:Literal> sản phẩm</h5>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-3 bg-white border shadow-sm">
                <div class="d-flex align-items-center">
                    <div class="p-3 bg-success-subtle text-success rounded-3 me-3">
                        <i class="bi bi-check2-circle fs-4"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Tổng số lượng đồ chơi tồn</div>
                        <h5 class="fw-bold mb-0 text-success"><asp:Literal ID="lblTongSoLuongTon" runat="server">0</asp:Literal> cái</h5>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-3">
        <!-- Bảng Danh sách Tồn Kho -->
        <div class="col-lg-8">
            <div class="card bg-white border shadow-sm" style="min-height: 300px;">
                <div class="card-header bg-light d-flex justify-content-between align-items-center py-2">
                    <span class="fw-bold"><i class="bi bi-table me-1"></i> Danh Sách Đồ Chơi Trong Kho</span>
                    <div class="w-50">
                        <asp:TextBox ID="txtTimKho" runat="server" AutoPostBack="true" OnTextChanged="txtTimKho_TextChanged"
                            CssClass="form-control form-control-sm" placeholder="Tìm theo tên đồ chơi..."></asp:TextBox>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 50px;" class="text-center">Mã</th>
                                <th>Tên đồ chơi</th>
                                <th>Loại</th>
                                <th class="text-end">Đơn giá</th>
                                <th class="text-center">Tồn kho</th>
                                <th class="text-center">Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptKho" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td class="fw-bold text-center">#<%# Eval("MaSP") %></td>
                                        <td class="fw-semibold text-dark">
                                            <div class="d-flex align-items-center gap-2">
                                                <img src='<%# Eval("HinhAnh") %>' style="width: 34px; height: 34px; object-fit: contain;" class="border rounded bg-white p-1"
                                                     onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1585366119957-e9730b6d0f60?w=500';" />
                                                <span><%# Eval("TenSP") %></span>
                                            </div>
                                        </td>
                                        <td><span class="badge bg-secondary-subtle text-secondary border"><%# Eval("Loai") %></span></td>
                                        <td class="text-end text-danger fw-bold"><%# string.Format("{0:N0} đ", Eval("Gia")) %></td>
                                        <td class="text-center fw-bold"><%# Eval("SoLuongTon") %></td>
                                        <td class="text-center">
                                            <span class='<%# Convert.ToInt32(Eval("SoLuongTon")) <= 0 ? "badge bg-danger" : Convert.ToInt32(Eval("SoLuongTon")) < 5 ? "badge bg-warning text-dark" : "badge bg-success" %>'>
                                                <%# Convert.ToInt32(Eval("SoLuongTon")) <= 0 ? "Hết hàng" : Convert.ToInt32(Eval("SoLuongTon")) < 5 ? "Sắp hết" : "Dồi dào" %>
                                            </span>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Form Nhập Thêm Số Lượng Kho -->
        <div class="col-lg-4">
            <div class="card bg-white border shadow-sm">
                <div class="card-header bg-light fw-bold py-2">
                    <i class="bi bi-download me-1 text-success"></i> Nhập Thêm Số Lượng Kho
                </div>
                <div class="card-body p-3">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Chọn sản phẩm nhập kho:</label>
                        <asp:DropDownList ID="ddlSanPhamNhap" runat="server" CssClass="form-select form-select-sm"></asp:DropDownList>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Số lượng nhập thêm:</label>
                        <asp:TextBox ID="txtSoLuongNhap" runat="server" TextMode="Number" Text="10" CssClass="form-control form-control-sm"></asp:TextBox>
                    </div>

                    <asp:Button ID="btnNhapKho" runat="server" Text="Xác Nhận Nhập Kho" OnClick="btnNhapKho_Click" CssClass="btn btn-success btn-sm w-100 fw-bold" />
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Form: Thêm sản phẩm mới -->
    <div class="modal fade" id="modalThemSP" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white py-2">
                    <h5 class="modal-title fw-bold fs-6">Thêm Sản Phẩm Đồ Chơi Mới</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-3">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Tên sản phẩm đồ chơi:</label>
                        <asp:TextBox ID="txtTenMoi" runat="server" CssClass="form-control form-control-sm" placeholder="Nhập tên sản phẩm..."></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Loại / Danh mục:</label>
                        <asp:DropDownList ID="ddlLoaiMoi" runat="server" CssClass="form-select form-select-sm">
                            <asp:ListItem Value="Mô hình">Mô hình</asp:ListItem>
                            <asp:ListItem Value="Lego">Lego</asp:ListItem>
                            <asp:ListItem Value="Búp bê">Búp bê</asp:ListItem>
                            <asp:ListItem Value="Xe mô hình">Xe mô hình</asp:ListItem>
                            <asp:ListItem Value="Boardgame">Boardgame</asp:ListItem>
                            <asp:ListItem Value="Đồ chơi giáo dục">Đồ chơi giáo dục</asp:ListItem>
                            <asp:ListItem Value="Khác">Khác</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Đơn giá bán (VNĐ):</label>
                            <asp:TextBox ID="txtGiaMoi" runat="server" TextMode="Number" Text="250000" CssClass="form-control form-control-sm"></asp:TextBox>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Tồn kho ban đầu:</label>
                            <asp:TextBox ID="txtTonBanDau" runat="server" TextMode="Number" Text="20" CssClass="form-control form-control-sm"></asp:TextBox>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Link Hình ảnh (Nếu có):</label>
                        <asp:TextBox ID="txtHinhAnhMoi" runat="server" CssClass="form-control form-control-sm" placeholder="https://..."></asp:TextBox>
                    </div>
                </div>
                <div class="modal-footer py-2">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Hủy bỏ</button>
                    <asp:Button ID="btnLuuSPMoi" runat="server" Text="Lưu Sản Phẩm" OnClick="btnLuuSPMoi_Click" CssClass="btn btn-primary btn-sm fw-bold" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
