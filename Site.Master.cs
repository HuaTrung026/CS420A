using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuanLyDoChoi
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                NguoiDung u = Session["User"] as NguoiDung;
                if (u != null)
                {
                    phUserInfo.Visible = true;
                    phLoginLink.Visible = false;
                    lblHoTen.Text = u.HoTen;
                    spanRole.InnerText = u.Quyen;
                    spanRole.Attributes["class"] = "role-pill role-" + u.Quyen;

                    // Menu permissions
                    phMenuBanHang.Visible = (u.Quyen == "Admin" || u.Quyen == "BanHang");
                    phMenuKho.Visible = (u.Quyen == "Admin" || u.Quyen == "Kho");
                    phMenuHoaDon.Visible = (u.Quyen == "Admin" || u.Quyen == "BanHang");
                }
                else
                {
                    phUserInfo.Visible = false;
                    phLoginLink.Visible = true;
                    phMenuBanHang.Visible = false;
                    phMenuKho.Visible = false;
                    phMenuHoaDon.Visible = false;
                }
            }
        }

        protected void btnDangXuat_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }
    }
}