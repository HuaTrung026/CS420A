<%@ Page Title="Lịch Sử Hóa Đơn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="HoaDon.aspx.cs" Inherits="QuanLyDoChoi.HoaDon" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h4 class="fw-bold text-primary mb-1"><i class="bi bi-journal-text me-1"></i> Lịch Sử Hóa Đơn Bán Hàng</h4>
            <p class="text-muted small mb-0">Danh sách các hóa đơn bán hàng và thông tin chi tiết từng đơn hàng</p>
        </div>
        <div>
            <a href="BanHang.aspx" class="btn btn-outline-primary btn-sm fw-semibold">
                <i class="bi bi-cart-plus me-1"></i> Tạo đơn mới
            </a>
        </div>
    </div>

    <!-- Hàng Thống Kê Nhanh (Cân đối khoảng trắng) -->
    <div class="row g-3 mb-3">
        <div class="col-md-4">
            <div class="card p-3 bg-white border shadow-sm">
                <div class="d-flex align-items-center">
                    <div class="p-3 bg-primary-subtle text-primary rounded-3 me-3">
                        <i class="bi bi-receipt fs-4"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Tổng số hóa đơn</div>
                        <h5 class="fw-bold mb-0 text-dark"><asp:Literal ID="lblTongSoHD" runat="server">0</asp:Literal> đơn hàng</h5>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-3 bg-white border shadow-sm">
                <div class="d-flex align-items-center">
                    <div class="p-3 bg-success-subtle text-success rounded-3 me-3">
                        <i class="bi bi-cash-stack fs-4"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Tổng doanh thu bán hàng</div>
                        <h5 class="fw-bold mb-0 text-success"><asp:Literal ID="lblTongDoanhThu" runat="server">0 đ</asp:Literal></h5>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-3 bg-white border shadow-sm">
                <div class="d-flex align-items-center">
                    <div class="p-3 bg-warning-subtle text-dark rounded-3 me-3">
                        <i class="bi bi-person-badge fs-4"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Thu ngân đang đăng nhập</div>
                        <h5 class="fw-bold mb-0 text-dark"><asp:Literal ID="lblThuNganHienTai" runat="server">Admin</asp:Literal></h5>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bảng Danh Sách Hóa Đơn -->
    <div class="card bg-white border shadow-sm" style="min-height: 250px;">
        <div class="card-header bg-light d-flex justify-content-between align-items-center py-2">
            <span class="fw-bold"><i class="bi bi-list-check me-1"></i> Danh Sách Hóa Đơn Gần Đây</span>
            <span class="badge bg-secondary">Hệ thống tự động lưu</span>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-bordered table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="text-center" style="width: 100px;">Mã HĐ</th>
                            <th>Thời gian lập</th>
                            <th>Người lập</th>
                            <th class="text-end">Tổng tiền</th>
                            <th class="text-center">Số món</th>
                            <th class="text-center" style="width: 120px;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptHoaDon" runat="server" OnItemCommand="rptHoaDon_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td class="text-center fw-bold text-primary">#<%# Eval("MaHD") %></td>
                                    <td><%# string.Format("{0:dd/MM/yyyy HH:mm}", Eval("NgayTao")) %></td>
                                    <td><span class="badge bg-light text-dark border"><%# Eval("NguoiTao") %></span></td>
                                    <td class="text-end fw-bold text-success"><%# string.Format("{0:N0} đ", Eval("TongTien")) %></td>
                                    <td class="text-center"><%# ((System.Collections.IList)Eval("ChiTiet")).Count %> sản phẩm</td>
                                    <td class="text-center">
                                        <asp:LinkButton ID="btnXemChiTiet" runat="server" CommandName="ViewDetail" CommandArgument='<%# Eval("MaHD") %>' CssClass="btn btn-sm btn-outline-primary py-0">
                                            Chi tiết
                                        </asp:LinkButton>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>

            <asp:PlaceHolder ID="phEmpty" runat="server" Visible="false">
                <div class="text-center py-5 text-muted small">
                    <i class="bi bi-inbox fs-1 d-block text-black-50 mb-2"></i>
                    Chưa có hóa đơn nào trong hệ thống.
                </div>
            </asp:PlaceHolder>
        </div>
    </div>

    <!-- Modal Chi Tiết Hóa Đơn -->
    <asp:PlaceHolder ID="phModalChiTiet" runat="server" Visible="false">
        <div class="modal fade show d-block" tabindex="-1" style="background: rgba(0,0,0,0.5);">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-dark text-white py-2">
                        <h5 class="modal-title fs-6 fw-bold">Chi Tiết Hóa Đơn #<asp:Literal ID="lblModalMaHD" runat="server"></asp:Literal></h5>
                        <asp:LinkButton ID="btnCloseModal" runat="server" OnClick="btnCloseModal_Click" CssClass="btn-close btn-close-white"></asp:LinkButton>
                    </div>
                    <div class="modal-body p-3">
                        <div class="row mb-3 bg-light p-2 border rounded g-2 small">
                            <div class="col-md-4">Mã hóa đơn: <strong>#<asp:Literal ID="lblModalMaHD2" runat="server"></asp:Literal></strong></div>
                            <div class="col-md-4">Thời gian: <strong><asp:Literal ID="lblModalNgay" runat="server"></asp:Literal></strong></div>
                            <div class="col-md-4">Thu ngân: <strong><asp:Literal ID="lblModalNguoiTao" runat="server"></asp:Literal></strong></div>
                        </div>

                        <table class="table table-sm table-bordered">
                            <thead class="table-light">
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th class="text-center">Số lượng</th>
                                    <th class="text-end">Đơn giá</th>
                                    <th class="text-end">Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptModalChiTiet" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td class="small"><%# Eval("TenSP") %></td>
                                            <td class="text-center small"><%# Eval("SoLuong") %></td>
                                            <td class="text-end small"><%# string.Format("{0:N0} đ", Eval("DonGia")) %></td>
                                            <td class="text-end small fw-bold text-success"><%# string.Format("{0:N0} đ", Eval("ThanhTien")) %></td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>

                        <div class="d-flex justify-content-between align-items-center bg-light p-2 border rounded">
                            <span class="fw-bold">TỔNG CỘNG:</span>
                            <span class="fw-bold text-danger fs-5"><asp:Literal ID="lblModalTongTien" runat="server"></asp:Literal> đ</span>
                        </div>
                    </div>
                    <div class="modal-footer py-2">
                        <asp:Button ID="btnCloseModal2" runat="server" Text="Đóng cửa sổ" OnClick="btnCloseModal_Click" CssClass="btn btn-secondary btn-sm fw-bold" />
                    </div>
                </div>
            </div>
        </div>
    </asp:PlaceHolder>
</asp:Content>
