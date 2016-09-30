using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class Logout : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            string kullaniciID = null;
            if (Session["userid"] == null)
            {
                HttpCookie CookieGetir = Response.Cookies["SiteLogin"];
                if (CookieGetir != null)
                {
                    CookieGetir.Expires = DateTime.Now.AddDays(-1);
                }
                Response.Redirect("~/Login.aspx"); return;
            }
            else kullaniciID = Session["userid"].ToString();
            if (kullaniciID != null)
            {
                Session.Remove("userid");
                Session.Remove("id");
                HttpCookie CookieGetir = Response.Cookies["SiteLogin"];
                if (CookieGetir != null)
                {
                    CookieGetir.Expires = DateTime.Now.AddDays(-1);
                }
                SqlConnection baglan = new SqlConnection(ConfigurationManager.ConnectionStrings["Baglanti"].ConnectionString);
                baglan.Open();
                SqlCommand ActiveRoomAdd = new SqlCommand("declare @datetime datetime = getdate() update Users set active_room_id = -1, logout_time = @datetime" + 
                    " where userid='" + kullaniciID + "'", baglan);
                ActiveRoomAdd.ExecuteNonQuery();
                baglan.Close();
                baglan.Dispose();
                Response.Redirect("~/Login.aspx"); return;
            }
        }
        catch (Exception) { }
    }
}