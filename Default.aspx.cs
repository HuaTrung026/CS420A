using System;
using System.Web.UI;

namespace QuanLyDoChoi
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            NguoiDung u = Session["User"] as NguoiDung;
            if (u == null)
            {
                Response.Redirect("~/Login.aspx");
            }
            else if (u.Quyen == "Kho")
            {
                Response.Redirect("~/QuanLyKho.aspx");
            }
            else
            {
                Response.Redirect("~/BanHang.aspx");
            }
        }
    }
}