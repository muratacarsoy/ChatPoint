using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;


public partial class RoomsMap : System.Web.UI.Page
{
    public string query_lat { get; set; }
    public string query_lng { get; set; }
    private SqlConnection SQLBaglantiAc()
    {
        SqlConnection baglan = new SqlConnection(ConfigurationManager.ConnectionStrings["Baglanti"].ConnectionString);

        try
        {
            if (baglan.State == ConnectionState.Closed)
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
            if (dbBaglanti.State == ConnectionState.Open)
            {
                dbBaglanti.Close();

                dbBaglanti.Dispose();
            }
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

        try
        {
            SqlCommand Rooms = new SqlCommand("SELECT RoomId,RoomName,(select count(*) from Users where login_time > logout_time and active_room_id = RoomId) as OnlineKisiSayisi, longitude, latitude, RoomStatus FROM Rooms where RoomStatus='A'", SQLBaglantiAc());

            SqlDataReader oku = Rooms.ExecuteReader();

            rep_rooms.DataSource = oku;

            rep_rooms.DataBind();

            SQLBaglantiKapat(SQLBaglantiAc());

            query_lat = Request.QueryString["lat"];
            query_lng = Request.QueryString["lng"];
            if (query_lat == null) { query_lat = "41.000000"; }
            else { query_lat = query_lat.Replace(",", "."); }
            if (query_lng == null) { query_lng = "29.000000"; }
            else { query_lng = query_lng.Replace(",", "."); }
        }
        catch (Exception hata)
        {
            lbl_error.Text = hata.ToString();

            lbl_error.Visible = true;
        }
    }
}