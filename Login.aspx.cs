using System;
using System.Web;
using System.Web.UI;

namespace QuanLyDoChoi
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["User"] != null)
                {
                    RedirectByRole((Session["User"] as NguoiDung).Quyen);
                }
            }
        }

        protected void btnDangNhap_Click(object sender, EventArgs e)
        {
            PerformLogin(txtTenDangNhap.Text.Trim(), txtMatKhau.Text.Trim());
        }

        protected void btnDemoAdmin_Click(object sender, EventArgs e)
        {
            PerformLogin("admin", "123456");
        }

        protected void btnDemoBanHang_Click(object sender, EventArgs e)
        {
            PerformLogin("banhang", "123456");
        }

        protected void btnDemoKho_Click(object sender, EventArgs e)
        {
            PerformLogin("kho", "123456");
        }

        private void PerformLogin(string username, string password)
        {
            NguoiDung user = DatabaseHelper.DangNhap(username, password);
            if (user != null)
            {
                Session["User"] = user;
                Session["Role"] = user.Quyen;
                RedirectByRole(user.Quyen);
            }
            else
            {
                pnlError.Visible = true;
                lblError.Text = "Tên đăng nhập hoặc mật khẩu không chính xác!";
            }
        }

        private void RedirectByRole(string role)
        {
            if (role == "Kho")
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
