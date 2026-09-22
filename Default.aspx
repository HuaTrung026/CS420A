<%@ Page Title="Trang Chủ" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="QuanLyDoChoi._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="p-5 mb-4 bg-light rounded-4 border shadow-sm">
        <div class="container-fluid py-3">
            <h1 class="display-5 fw-bold text-primary mb-3">
                <i class="bi bi-box-seam-fill me-2 text-warning"></i>Cửa Hàng Đồ Chơi ToyStore
            </h1>
            <p class="col-md-10 fs-5 text-secondary">
                Hệ thống Quản lý Bán hàng, Nhập kho và Theo dõi Đơn hàng tự động dành cho Cửa Hàng Đồ Chơi.
            </p>
            <hr class="my-4" />
            <div class="d-flex gap-3">
                <a href="BanHang.aspx" class="btn btn-primary btn-lg rounded-3 fw-bold">
                    <i class="bi bi-cart3 me-1"></i> Trang Bán Hàng (POS)
                </a>
                <a href="QuanLyKho.aspx" class="btn btn-warning btn-lg rounded-3 fw-bold text-dark">
                    <i class="bi bi-boxes me-1"></i> Trang Quản Lý Kho
                </a>
            </div>
        </div>
    </div>
</asp:Content>
