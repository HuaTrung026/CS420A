using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuanLyDoChoi
{
    public partial class QuanLyKho : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            NguoiDung u = Session["User"] as NguoiDung;
            if (u == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (u.Quyen != "Admin" && u.Quyen != "Kho")
            {
                Response.Redirect("~/BanHang.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadData();
            }
        }

        private void LoadData(string kw = "")
        {
            List<SanPham> list = DatabaseHelper.GetDanhSachSanPham(kw);
            rptKho.DataSource = list;
            rptKho.DataBind();

            // Tính toán số liệu thống kê kho
            List<SanPham> allProducts = DatabaseHelper.GetDanhSachSanPham("");
            lblTongMatHang.Text = allProducts.Count.ToString();
            int canhBaoCount = 0;
            int tongTon = 0;
            foreach (var p in allProducts)
            {
                if (p.SoLuongTon < 5) canhBaoCount++;
                tongTon += p.SoLuongTon;
            }
            lblCanhBao.Text = canhBaoCount.ToString();
            lblTongSoLuongTon.Text = tongTon.ToString();

            if (string.IsNullOrEmpty(kw))
            {
                ddlSanPhamNhap.Items.Clear();
                foreach (var p in list)
                {
                    ddlSanPhamNhap.Items.Add(new ListItem(string.Format("{0} (Hiện tồn: {1})", p.TenSP, p.SoLuongTon), p.MaSP.ToString()));
                }
            }
        }

        protected void txtTimKho_TextChanged(object sender, EventArgs e)
        {
            LoadData(txtTimKho.Text.Trim());
        }

        protected void btnNhapKho_Click(object sender, EventArgs e)
        {
            if (ddlSanPhamNhap.SelectedItem == null)
            {
                ShowAlert("Không có sản phẩm nào được chọn!", "warning");
                return;
            }

            int maSP = Convert.ToInt32(ddlSanPhamNhap.SelectedValue);
            int soLuongNhap;
            if (!int.TryParse(txtSoLuongNhap.Text, out soLuongNhap) || soLuongNhap <= 0)
            {
                ShowAlert("Số lượng nhập kho phải lớn hơn 0!", "warning");
                return;
            }

            if (DatabaseHelper.NhapThemKho(maSP, soLuongNhap))
            {
                ShowAlert(string.Format("Đã nhập thành công +{0} sản phẩm vào kho!", soLuongNhap), "success");
                LoadData();
            }
            else
            {
                ShowAlert("Có lỗi xảy ra khi cập nhật số lượng nhập kho!", "danger");
            }
        }

        protected void btnLuuSPMoi_Click(object sender, EventArgs e)
        {
            string ten = txtTenMoi.Text.Trim();
            string loai = ddlLoaiMoi.SelectedValue;
            decimal gia;
            int ton;
            string img = txtHinhAnhMoi.Text.Trim();

            if (string.IsNullOrWhiteSpace(ten))
            {
                ShowAlert("Tên sản phẩm không được để trống!", "warning");
                return;
            }

            if (!decimal.TryParse(txtGiaMoi.Text, out gia) || gia < 0)
            {
                ShowAlert("Đơn giá không hợp lệ!", "warning");
                return;
            }

            if (!int.TryParse(txtTonBanDau.Text, out ton) || ton < 0)
            {
                ShowAlert("Số lượng tồn ban đầu phải lớn hơn hoặc bằng 0!", "warning");
                return;
            }

            if (DatabaseHelper.ThemSanPham(ten, loai, gia, ton, img))
            {
                ShowAlert(string.Format("Đã thêm thành công sản phẩm đồ chơi mới: '{0}'!", ten), "success");
                txtTenMoi.Text = "";
                txtHinhAnhMoi.Text = "";
                LoadData();
            }
            else
            {
                ShowAlert("Có lỗi xảy ra khi lưu sản phẩm mới!", "danger");
            }
        }

        private void ShowAlert(string msg, string type)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = string.Format("alert alert-{0} alert-dismissible fade show rounded-4 mb-4 shadow-sm", type);
            lblAlertMsg.Text = msg;
        }
    }
}
