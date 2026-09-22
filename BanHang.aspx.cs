using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuanLyDoChoi
{
    public partial class BanHang : Page
    {
        private List<ChiTietHoaDonModel> Cart
        {
            get
            {
                if (Session["Cart"] == null)
                {
                    Session["Cart"] = new List<ChiTietHoaDonModel>();
                }
                return (List<ChiTietHoaDonModel>)Session["Cart"];
            }
            set
            {
                Session["Cart"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            NguoiDung u = Session["User"] as NguoiDung;
            if (u == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (u.Quyen != "Admin" && u.Quyen != "BanHang")
            {
                Response.Redirect("~/QuanLyKho.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProducts();
                BindCart();
            }
        }

        private void LoadProducts(string kw = "")
        {
            List<SanPham> list = DatabaseHelper.GetDanhSachSanPham(kw);
            rptSanPham.DataSource = list;
            rptSanPham.DataBind();
        }

        protected void btnTimKiem_Click(object sender, EventArgs e)
        {
            LoadProducts(txtTimKiem.Text.Trim());
        }

        protected void btnTatCa_Click(object sender, EventArgs e)
        {
            txtTimKiem.Text = "";
            LoadProducts();
        }

        protected void rptSanPham_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "AddToCart")
            {
                int maSP = Convert.ToInt32(e.CommandArgument);
                List<SanPham> allProducts = DatabaseHelper.GetDanhSachSanPham();
                SanPham target = allProducts.Find(p => p.MaSP == maSP);

                if (target != null && target.SoLuongTon > 0)
                {
                    List<ChiTietHoaDonModel> cart = Cart;
                    ChiTietHoaDonModel existing = cart.Find(c => c.MaSP == maSP);
                    if (existing != null)
                    {
                        if (existing.SoLuong + 1 <= target.SoLuongTon)
                        {
                            existing.SoLuong++;
                            existing.ThanhTien = existing.SoLuong * existing.DonGia;
                        }
                        else
                        {
                            ShowAlert(string.Format("Sản phẩm '{0}' chỉ còn tồn {1} sản phẩm!", target.TenSP, target.SoLuongTon), "warning");
                        }
                    }
                    else
                    {
                        cart.Add(new ChiTietHoaDonModel
                        {
                            MaSP = target.MaSP,
                            TenSP = target.TenSP,
                            SoLuong = 1,
                            DonGia = target.Gia,
                            ThanhTien = target.Gia
                        });
                    }
                    Cart = cart;
                    BindCart();
                }
            }
        }

        protected void rptGioHang_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int maSP = Convert.ToInt32(e.CommandArgument);
            List<ChiTietHoaDonModel> cart = Cart;
            ChiTietHoaDonModel item = cart.Find(c => c.MaSP == maSP);

            if (item != null)
            {
                if (e.CommandName == "AddQty")
                {
                    List<SanPham> allProducts = DatabaseHelper.GetDanhSachSanPham();
                    SanPham target = allProducts.Find(p => p.MaSP == maSP);
                    if (target != null && item.SoLuong + 1 <= target.SoLuongTon)
                    {
                        item.SoLuong++;
                        item.ThanhTien = item.SoLuong * item.DonGia;
                    }
                    else
                    {
                        ShowAlert(string.Format("Không thể tăng số lượng vì tồn kho tối đa là {0}!", target != null ? target.SoLuongTon : 0), "warning");
                    }
                }
                else if (e.CommandName == "SubQty")
                {
                    item.SoLuong--;
                    if (item.SoLuong <= 0)
                    {
                        cart.Remove(item);
                    }
                    else
                    {
                        item.ThanhTien = item.SoLuong * item.DonGia;
                    }
                }
                else if (e.CommandName == "RemoveItem")
                {
                    cart.Remove(item);
                }
            }

            Cart = cart;
            BindCart();
        }

        protected void btnXoaGioHang_Click(object sender, EventArgs e)
        {
            Cart.Clear();
            BindCart();
        }

        private void BindCart()
        {
            List<ChiTietHoaDonModel> cart = Cart;
            rptGioHang.DataSource = cart;
            rptGioHang.DataBind();

            phEmptyCart.Visible = (cart.Count == 0);

            decimal tong = 0;
            foreach (var item in cart)
            {
                tong += item.ThanhTien;
            }
            lblTongTien.Text = string.Format("{0:N0} đ", tong);
            btnThanhToan.Enabled = (cart.Count > 0);
        }

        protected void btnThanhToan_Click(object sender, EventArgs e)
        {
            NguoiDung u = Session["User"] as NguoiDung;
            List<ChiTietHoaDonModel> cart = Cart;

            if (cart.Count == 0)
            {
                ShowAlert("Vui lòng chọn ít nhất 1 sản phẩm đồ chơi để thanh toán!", "warning");
                return;
            }

            string error;
            int maHD = DatabaseHelper.ThanhToanHoaDon(u.TenDangNhap, cart, out error);

            if (maHD > 0)
            {
                decimal tongTien = 0;
                foreach (var item in cart) tongTien += item.ThanhTien;

                lblModalMaHD.Text = maHD.ToString();
                lblModalNgay.Text = DateTime.Now.ToString("dd/MM/yyyy HH:mm");
                lblModalNguoiTao.Text = u.HoTen;
                lblModalTongTien.Text = string.Format("{0:N0}", tongTien);

                rptModalChiTiet.DataSource = new List<ChiTietHoaDonModel>(cart);
                rptModalChiTiet.DataBind();

                phModalHoaDon.Visible = true;

                // Clear cart & Refresh products list
                Cart.Clear();
                BindCart();
                LoadProducts();
            }
            else
            {
                ShowAlert("Thanh toán thất bại: " + error, "danger");
            }
        }

        protected void btnCloseModal_Click(object sender, EventArgs e)
        {
            phModalHoaDon.Visible = false;
        }

        private void ShowAlert(string msg, string type)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = string.Format("alert alert-{0} alert-dismissible fade show rounded-4 mb-4 shadow-sm", type);
            lblAlertMsg.Text = msg;
        }
    }
}
