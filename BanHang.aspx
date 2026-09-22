<%@ Page Title="Bán Hàng" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BanHang.aspx.cs" Inherits="QuanLyDoChoi.BanHang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row mb-3">
        <div class="col-md-12">
            <h4 class="fw-bold text-primary mb-1"><i class="bi bi-cart3"></i> Màn Hình Bán Hàng (POS)</h4>
            <p class="text-muted small">Tra cứu danh mục đồ chơi, chọn sản phẩm và tạo hóa đơn bán hàng</p>
        </div>
    </div>

    <!-- Alert Thông báo -->
    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="alert alert-dismissible fade show" role="alert">
        <asp:Literal ID="lblAlertMsg" runat="server"></asp:Literal>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </asp:Panel>

    <div class="row g-3">
        <!-- Bên trái: Danh sách Sản phẩm & Tìm kiếm -->
        <div class="col-lg-7 col-xl-8">
            <div class="card mb-3">
                <div class="card-body py-2">
                    <div class="row g-2 align-items-center">
                        <div class="col-md-8">
                            <div class="input-group input-group-sm">
                                <span class="input-group-text"><i class="bi bi-search"></i></span>
                                <asp:TextBox ID="txtTimKiem" runat="server" CssClass="form-control" placeholder="Nhập tên sản phẩm (Gundam, Lego, Búp bê...)..."></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-4 d-flex gap-2">
                            <asp:Button ID="btnTimKiem" runat="server" Text="Tìm kiếm" OnClick="btnTimKiem_Click" CssClass="btn btn-primary btn-sm flex-grow-1" />
                            <asp:Button ID="btnTatCa" runat="server" Text="Tất cả" OnClick="btnTatCa_Click" CssClass="btn btn-outline-secondary btn-sm" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Grid Danh sách Đồ Chơi -->
            <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
                <asp:Repeater ID="rptSanPham" runat="server" OnItemCommand="rptSanPham_ItemCommand">
                    <ItemTemplate>
                        <div class="col">
                            <div class="card h-100 bg-white border shadow-sm">
                                <div class="bg-white border-bottom p-2 d-flex align-items-center justify-content-center position-relative" style="height: 155px;">
                                    <img src='<%# Eval("HinhAnh") %>' class="img-fluid" style="max-height: 140px; max-width: 100%; object-fit: contain;" alt='<%# Eval("TenSP") %>'
                                         onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1585366119957-e9730b6d0f60?w=500';" />
                                    <span class="position-absolute top-0 start-0 m-2 badge bg-secondary" style="font-size: 0.72rem;"><%# Eval("Loai") %></span>
                                </div>
                                <div class="card-body p-3 d-flex flex-column">
                                    <h6 class="card-title fw-bold text-dark text-truncate mb-2" title='<%# Eval("TenSP") %>'><%# Eval("TenSP") %></h6>
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <span class="fw-bold text-danger fs-6"><%# string.Format("{0:N0} đ", Eval("Gia")) %></span>
                                        <span class='<%# Convert.ToInt32(Eval("SoLuongTon")) < 5 ? "badge bg-danger" : "badge bg-success" %>'>
                                            Tồn: <%# Eval("SoLuongTon") %>
                                        </span>
                                    </div>
                                    <div class="mt-auto">
                                        <asp:LinkButton ID="btnChon" runat="server" CommandName="AddToCart" CommandArgument='<%# Eval("MaSP") %>'
                                            CssClass='<%# Convert.ToInt32(Eval("SoLuongTon")) <= 0 ? "btn btn-secondary btn-sm w-100 disabled" : "btn btn-outline-primary btn-sm w-100 fw-semibold" %>'>
                                            <i class="bi bi-plus-circle"></i> <%# Convert.ToInt32(Eval("SoLuongTon")) <= 0 ? "Hết Hàng" : "Thêm Vào Đơn" %>
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <!-- Bên phải: Đơn hàng & Thanh toán -->
        <div class="col-lg-5 col-xl-4">
            <div class="card sticky-top" style="top: 80px;">
                <div class="card-header bg-light d-flex justify-content-between align-items-center">
                    <span class="fw-bold"><i class="bi bi-receipt-cutoff"></i> Đơn Hàng Hiện Tại</span>
                    <asp:LinkButton ID="btnXoaGioHang" runat="server" OnClick="btnXoaGioHang_Click" CssClass="text-danger small text-decoration-none">
                        <i class="bi bi-trash"></i> Xóa đơn
                    </asp:LinkButton>
                </div>

                <div class="card-body p-3">
                    <div style="max-height: 300px; overflow-y: auto;" class="mb-3">
                        <asp:Repeater ID="rptGioHang" runat="server" OnItemCommand="rptGioHang_ItemCommand">
                            <HeaderTemplate>
                                <table class="table table-sm align-middle">
                                    <thead>
                                        <tr>
                                            <th>Sản phẩm</th>
                                            <th class="text-center" style="width: 80px;">SL</th>
                                            <th class="text-end">Thành tiền</th>
                                            <th style="width: 30px;"></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <div class="fw-semibold small text-truncate" style="max-width: 120px;" title='<%# Eval("TenSP") %>'><%# Eval("TenSP") %></div>
                                        <div class="text-muted small"><%# string.Format("{0:N0}", Eval("DonGia")) %></div>
                                    </td>
                                    <td class="text-center">
                                        <div class="btn-group btn-group-sm">
                                            <asp:LinkButton ID="btnGiam" runat="server" CommandName="SubQty" CommandArgument='<%# Eval("MaSP") %>' CssClass="btn btn-light border px-1 py-0">-</asp:LinkButton>
                                            <span class="px-2 small fw-bold bg-white border-top border-bottom py-0"><%# Eval("SoLuong") %></span>
                                            <asp:LinkButton ID="btnTang" runat="server" CommandName="AddQty" CommandArgument='<%# Eval("MaSP") %>' CssClass="btn btn-light border px-1 py-0">+</asp:LinkButton>
                                        </div>
                                    </td>
                                    <td class="text-end fw-bold text-primary small">
                                        <%# string.Format("{0:N0}", Eval("ThanhTien")) %>
                                    </td>
                                    <td>
                                        <asp:LinkButton ID="btnXoa" runat="server" CommandName="RemoveItem" CommandArgument='<%# Eval("MaSP") %>' CssClass="text-danger"><i class="bi bi-x"></i></asp:LinkButton>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                    </tbody>
                                </table>
                            </FooterTemplate>
                        </asp:Repeater>

                        <asp:PlaceHolder ID="phEmptyCart" runat="server">
                            <div class="text-center py-4 text-muted small">
                                Giỏ hàng đang trống
                            </div>
                        </asp:PlaceHolder>
                    </div>

                    <div class="border-top pt-3">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="fw-bold">Tổng tiền:</span>
                            <span class="fw-bold text-success fs-4"><asp:Literal ID="lblTongTien" runat="server" Text="0 đ"></asp:Literal></span>
                        </div>

                        <asp:Button ID="btnThanhToan" runat="server" Text="THANH TOÁN & IN HÓA ĐƠN" OnClick="btnThanhToan_Click"
                            CssClass="btn btn-success btn-lg w-100 fw-bold shadow-sm" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Xem & Xác nhận Hóa Đơn -->
    <asp:PlaceHolder ID="phModalHoaDon" runat="server" Visible="false">
        <div class="modal fade show d-block" tabindex="-1" style="background: rgba(0,0,0,0.5);">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white py-2">
                        <h5 class="modal-title fw-bold fs-6">HÓA ĐƠN BÁN HÀNG #<asp:Literal ID="lblModalMaHD" runat="server"></asp:Literal></h5>
                        <asp:LinkButton ID="btnCloseModal" runat="server" OnClick="btnCloseModal_Click" CssClass="btn-close btn-close-white"></asp:LinkButton>
                    </div>
                    <div class="modal-body p-3">
                        <div class="text-center mb-3">
                            <h5 class="fw-bold mb-1">CỬA HÀNG ĐỒ CHƠI</h5>
                            <p class="text-muted small mb-0">Ngày: <asp:Literal ID="lblModalNgay" runat="server"></asp:Literal> | Thu ngân: <strong><asp:Literal ID="lblModalNguoiTao" runat="server"></asp:Literal></strong></p>
                        </div>
                        <table class="table table-sm table-bordered">
                            <thead class="table-light">
                                <tr>
                                    <th>Sản phẩm</th>
                                    <th class="text-center">SL</th>
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
                                            <td class="text-end small"><%# string.Format("{0:N0}", Eval("DonGia")) %></td>
                                            <td class="text-end small fw-bold"><%# string.Format("{0:N0}", Eval("ThanhTien")) %></td>
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
                        <asp:Button ID="btnCloseModal2" runat="server" Text="Hoàn tất & Đóng" OnClick="btnCloseModal_Click" CssClass="btn btn-secondary btn-sm fw-bold w-100" />
                    </div>
                </div>
            </div>
        </div>
    </asp:PlaceHolder>
</asp:Content>
