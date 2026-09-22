using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuanLyDoChoi
{
    public partial class HoaDon : Page
    {
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
                LoadInvoices();
            }
        }

        private void LoadInvoices()
        {
            List<HoaDonModel> list = DatabaseHelper.GetDanhSachHoaDon();
            rptHoaDon.DataSource = list;
            rptHoaDon.DataBind();

            phEmpty.Visible = (list.Count == 0);

            decimal tongDoanhThu = 0;
            foreach (var hd in list)
            {
                tongDoanhThu += hd.TongTien;
            }
            lblTongSoHD.Text = list.Count.ToString();
            lblTongDoanhThu.Text = string.Format("{0:N0} đ", tongDoanhThu);

            NguoiDung u = Session["User"] as NguoiDung;
            if (u != null)
            {
                lblThuNganHienTai.Text = u.HoTen;
            }
        }

        protected void rptHoaDon_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetail")
            {
                int maHD = Convert.ToInt32(e.CommandArgument);
                List<HoaDonModel> list = DatabaseHelper.GetDanhSachHoaDon();
                HoaDonModel target = list.Find(h => h.MaHD == maHD);

                if (target != null)
                {
                    lblModalMaHD.Text = target.MaHD.ToString();
                    lblModalMaHD2.Text = target.MaHD.ToString();
                    lblModalNgay.Text = target.NgayTao.ToString("dd/MM/yyyy HH:mm");
                    lblModalNguoiTao.Text = target.NguoiTao;
                    lblModalTongTien.Text = string.Format("{0:N0}", target.TongTien);

                    rptModalChiTiet.DataSource = target.ChiTiet;
                    rptModalChiTiet.DataBind();

                    phModalChiTiet.Visible = true;
                }
            }
        }

        protected void btnCloseModal_Click(object sender, EventArgs e)
        {
            phModalChiTiet.Visible = false;
        }
    }
}
