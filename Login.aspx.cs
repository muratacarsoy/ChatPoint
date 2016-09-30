using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class Login : System.Web.UI.Page
{
    private SqlConnection SQLBaglantiAc()
    {
        SqlConnection baglan = new SqlConnection(ConfigurationManager.ConnectionStrings["Baglanti"].ConnectionString);
        try
        {
            if (baglan.State==ConnectionState.Closed)
            {
                baglan.Open();
            }
        }
        catch (Exception e)
        {
            lbl_error.Visible = true;
            lbl_error.Text = e.ToString();
        }
        return baglan;
    }

    private void SQLBaglantiKapat(SqlConnection dbBaglanti)
    { 
        try
        {
            if (dbBaglanti.State == ConnectionState.Open) { dbBaglanti.Close(); dbBaglanti.Dispose(); }
        }
        catch (Exception e)
        {
            lbl_error.Visible = true;
            lbl_error.Text = e.ToString();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        lbl_error.Visible = false;
        HttpCookie CookieGetir = Request.Cookies["SiteLogin"];
        if (CookieGetir != null)
        {
            Session["userid"] = CookieGetir["userid"];
            Session["id"] = CookieGetir["id"];
            Response.Redirect("~/ChatRooms.aspx");
        }
    }

    protected void btn_giris_Click(object sender, EventArgs e)
    {
        lbl_error.Visible = false;
        try
        {
            SqlCommand UserKontrol = new SqlCommand("exec RunLogin '" +
                txt_userid.Value + "', '" + txt_password.Value + "'", SQLBaglantiAc());
            SqlDataReader OkuUserID = UserKontrol.ExecuteReader();
            while (OkuUserID.Read())
            {
                if (Convert.ToInt32(OkuUserID["say"]) > 0 && Convert.ToInt32(OkuUserID["izin"]) > 0)
                {
                    Session.Add("userid", txt_userid.Value); Session.Add("logDate", DateTime.Now);
                    string _id = OkuUserID["id"].ToString();
                    Session.Add("id", _id);
                    if (check_beni_hatirla.Checked)
                    {
                        HttpCookie CookieLogin = new HttpCookie("SiteLogin");
                        CookieLogin["userid"] = txt_userid.Value;
                        CookieLogin["id"] = _id;
                        Response.Cookies.Add(CookieLogin);
                        Response.Cookies["SiteLogin"].Expires = DateTime.Now.AddDays(7);
                    }
                    SqlCommand LogEkle = new SqlCommand("declare @datetime datetime = getdate() exec AddLog '" + Session["userid"].ToString() + "',@datetime,'I'", SQLBaglantiAc());
                    LogEkle.ExecuteNonQuery();
                    SQLBaglantiKapat(SQLBaglantiAc());
                    Response.Redirect("~/ChatRooms.aspx");
                }
                else { lbl_error.Visible = true; lbl_error.Text = OkuUserID["durum"].ToString(); }
            }
        }
        catch (Exception hata) { lbl_error.Visible = true; lbl_error.Text = hata.ToString(); }
    }
    protected void btn_Kaydol_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Register.aspx");
    }
    protected void btn_sifremi_unuttum_Click(object sender, EventArgs e)
    {

    }
}