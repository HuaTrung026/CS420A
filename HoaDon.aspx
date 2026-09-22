<%@ Page Title="Lịch Sử Hóa Đơn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="HoaDon.aspx.cs" Inherits="QuanLyDoChoi.HoaDon" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row mb-3">
        <div class="col-md-12">
            <h4 class="fw-bold text-primary mb-1"><i class="bi bi-journal-text"></i> Lịch Sử Hóa Đơn Bán Hàng</h4>
            <p class="text-muted small">Xem lại danh sách các hóa đơn bán hàng đã lưu trong hệ thống</p>
        </div>
    </div>

    <div class="card">
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
                <div class="text-center py-4 text-muted small">
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
