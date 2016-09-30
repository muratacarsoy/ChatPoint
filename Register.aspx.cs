using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Threading;

public partial class Register : System.Web.UI.Page
{
    private string picture_gender;
    private string[] picture_list;
    private int picture_list_index;
    private static int _index;

    private SqlConnection SQLBaglantiAc()
    {
        SqlConnection baglan = new SqlConnection(ConfigurationManager.ConnectionStrings["Baglanti"].ConnectionString);
        try
        {
            if (baglan.State == ConnectionState.Closed) { baglan.Open(); }
        }
        catch (Exception e)
        { lbl_error.Visible = true; lbl_error.Text = e.ToString(); }
        return baglan;
    }

    private void SQLBaglantiKapat(SqlConnection dbBaglanti)
    {
        try
        {
            if (dbBaglanti.State == ConnectionState.Open) { dbBaglanti.Close(); dbBaglanti.Dispose(); }
        }
        catch (Exception e)
        { lbl_error.Visible = true; lbl_error.Text = e.ToString(); }

    }

    protected void Page_Load(object sender, EventArgs e)
    {
        _index = 0;
        lbl_sifre_eslesmiyor.Visible = false; picture_gender = "male";
        picture_list = new string[13]{ "/user.png", "/young.png", "/red.png", "/gn.png", "/person.png", "/doctor.png", "/glass.png", "/clerk.png", "/teacher.png", "/sailor.png", "/photographer.png", "/chef.png", "/farmer.png" };
    }

    protected void btn_Kaydol_Click(object sender, EventArgs e)
    {
        try
        {
            if (txt_password.Value != txt_passwordTekrar.Value)
            { lbl_sifre_eslesmiyor.Visible = true; lbl_sifre_eslesmiyor.Text = "Şifreler Eşleşmiyor !"; }
            else if (!bay.Checked && !bayan.Checked) {
                lbl_sifre_eslesmiyor.Visible = true; lbl_sifre_eslesmiyor.Text = "Cinsiyet seçilmedi !";
            }
            else if (txt_userid.Value.Contains("!") || txt_userid.Value.Contains("#") || txt_userid.Value.Contains("*") || txt_userid.Value.Contains("+")
                || txt_userid.Value.Contains("<") || txt_userid.Value.Contains(">") || txt_userid.Value.Contains(","))
            {
                lbl_sifre_eslesmiyor.Visible = true; lbl_sifre_eslesmiyor.Text = "Geçersiz bir mail girdiniz !";
            }
            else if (txt_Rumuz.Value.Contains("!") || txt_Rumuz.Value.Contains("#") || txt_Rumuz.Value.Contains("*") || txt_Rumuz.Value.Contains("+")
                || txt_Rumuz.Value.Contains("<") || txt_Rumuz.Value.Contains(">") || txt_Rumuz.Value.Contains(","))
            {
                lbl_sifre_eslesmiyor.Visible = true; lbl_sifre_eslesmiyor.Text = "Geçersiz bir rumuz girdiniz !";
            }
            else
            {
                string cinsiyet;
                if (bay.Checked) { cinsiyet = "Bay"; }
                else { cinsiyet = "Bayan"; }
                SqlCommand Add = new SqlCommand("declare @sonuc varchar(100) exec AddUser '" +
                    txt_userid.Value.Replace("'", "") + "' ,'" + txt_password.Value.Replace("'", "''") + "','" + txt_Rumuz.Value.Replace("'", "") + 
                    "','" + cinsiyet + "', " + hidden_index.Value + " , @durum=@sonuc Output select @sonuc as 'KayitDurumu' ", SQLBaglantiAc());
                SqlDataReader oku = Add.ExecuteReader();
                while (oku.Read())
                {
                    Response.Write("<script>alert('" + oku["KayitDurumu"].ToString() + "')</script>");
                }
                SQLBaglantiKapat(SQLBaglantiAc());
                Response.Redirect("~/Login.aspx");
            }
        }
        catch (Exception ex)
        {  
            lbl_error.Text = ex.ToString();
        }
    }
}
