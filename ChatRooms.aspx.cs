using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Services;


public partial class ChatRooms : System.Web.UI.Page
{
    private static string us_id;

    public class odalar
    {
        public string satir { get; set; }
    }
 
    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static List<odalar> ChatOdalariniGetir()
    {
        List<odalar> satirListesi = new List<odalar>();
        using (SqlConnection conn = new SqlConnection())
        {
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["Baglanti"].ConnectionString;
            using (SqlCommand cmd = new SqlCommand())
            { // select dbo.TotalOnlineRoomUserQuantity(RoomId)
                cmd.CommandText = "SELECT RoomId,'<a class=\"a_room_link\" href=\"ChatPage.aspx?uid=" + us_id +
                    "&rid='+cast(RoomId as varchar(10))+'\">'+RoomName+'</a>' as link,(select count(*) from Users where login_time > logout_time and active_room_id = RoomId) as OnlineKisiSayisi" +
                    ",longitude,latitude,RoomStatus FROM Rooms where RoomStatus='A'";
                cmd.Connection = conn;
                conn.Open();
                using(SqlDataReader oku = cmd.ExecuteReader())
                {
                    while (oku.Read())
                    {
                        odalar liste = new odalar();
                        string link = oku["link"].ToString(), online_kisi_sayisi = oku["OnlineKisiSayisi"].ToString(), 
                            lng = oku["longitude"].ToString(), lat = oku["latitude"].ToString(), id = oku["RoomId"].ToString();
                        string _satir = "";
                        _satir += "<div class=\"tr\"><div class=\"td\"><b>" + link + "</b></div><div class=\"td\"><b>" + 
                            online_kisi_sayisi + "</b></div><div class=\"td\"><a class=\"map_link\" href=\"/RoomsMap.aspx?lat=" + 
                            lat + "&lng=" + lng + "\"><div id=\"room_map" + id + "\" class=\"room_map\"></div>" +
                            "<input id=\"lat" + id + "\" style=\"display:none\" value=\"" + lat + "\" />" +
                            "<input id=\"lng" + id + "\" style=\"display:none\" value=\"" + lng + "\" />" +
                            "</a><div class=\"td\"><span id=\"uzaklik_" + id + "\">1000m</span></div></div></div>";
                        liste.satir = _satir;
                        satirListesi.Add(liste);
                    }
                }
                SqlCommand TotalOnlineUserQuantity = new SqlCommand("select count(*) as total from Users where login_time > logout_time", conn);
                SqlDataReader okuTotal = TotalOnlineUserQuantity.ExecuteReader();
                while (okuTotal.Read())
                {
                    satirListesi.Add(new odalar() { satir = "<div><div class=\"td\"><span id=\"lbl_totalonlineusersquantity\"> Online Kullanıcı Sayısı : " 
                        + okuTotal["total"].ToString() + "</span></div></div>" });
                }
                conn.Close();
                conn.Dispose();
            }
        }

        return satirListesi;
    }

    private SqlConnection SQLBaglantiAc()
    {
        SqlConnection baglan = new SqlConnection(ConfigurationManager.ConnectionStrings["Baglanti"].ConnectionString);
        try
        {
            if (baglan.State == ConnectionState.Closed) { baglan.Open(); }
        }
        catch (Exception hata) { lbl_error.Text = hata.ToString(); lbl_error.Visible = true; }
        return baglan;
    }

    private void SQLBaglantiKapat(SqlConnection dbBaglanti)
    {
        try
        {
            if (dbBaglanti.State == ConnectionState.Open) { dbBaglanti.Close(); dbBaglanti.Dispose(); }
        }
        catch (Exception hata) { lbl_error.Text = hata.ToString(); lbl_error.Visible = true; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        lbl_error.Visible = false;
        if (Session["userid"] == null || Session["id"] == null) { Response.Redirect("~/login.aspx"); return; }
        us_id = Session["userid"].ToString();
        hidden_id.Value = Session["id"].ToString();
        try
        {
            SqlCommand Rooms = new SqlCommand("SELECT RoomId,'<a class=\"a_room_link\" href=\"ChatPage.aspx?uid=" + Session["userid"] +
                "&rid='+cast(RoomId as varchar(10))+'\">'+RoomName+'</a>' as link,(select count(*) from Users where login_time > logout_time and active_room_id = RoomId) as OnlineKisiSayisi,longitude,latitude,RoomStatus FROM Rooms where RoomStatus='A'", SQLBaglantiAc());
            SqlDataReader oku = Rooms.ExecuteReader();
            rep_Rooms.DataSource = oku;
            rep_Rooms.DataBind();
            SqlCommand TotalOnlineUserQuantity = new SqlCommand("select count(*) as total from Users where login_time > logout_time", SQLBaglantiAc());
            SqlDataReader okuTotal = TotalOnlineUserQuantity.ExecuteReader();
            while (okuTotal.Read())
            {
                lbl_totalonlineusersquantity.Text = " Online Kullanıcı Sayısı : " + okuTotal["total"].ToString();
            }
            SQLBaglantiKapat(SQLBaglantiAc());
        }
        catch (Exception hata) { lbl_error.Text = hata.ToString(); lbl_error.Visible = true; }
    }

    public class MessageYaz { public string msg { get; set; } }

    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string SendRelation(string ourid, string targetid, string buttontype)
    {
        string command_text = "";
        if (buttontype == "64")         //Arkadaşlık isteğini kabul et
        {
            command_text = "update Relations set RelationType = 'F', RelationTime = getdate(), RelationSeen = 'H' where SentUserId = " +
                targetid + " and TookUserId = " + ourid + " and RelationType = 'I'";
        }
        else if (buttontype == "32")    //Arkadaşlık isteğini reddet
        {
            command_text = "update Relations set RelationType = 'R', RelationTime = getdate(), RelationSeen = 'H' where SentUserId = " +
                targetid + " and TookUserId = " + ourid + " and RelationType = 'I'";
        }
        else if (buttontype == "16")    //Arkadaşlığı boz
        {
            command_text = "delete from Relations where RelationType = 'F' and ((SentUserId = " +
                ourid + " and TookUserId = " + targetid + ") or (TookUserId = " + ourid + " and SentUserId = " + targetid + "))";
        }
        else if (buttontype == "8")     //Engeli kaldır
        {
            command_text = "delete from Relations where RelationType = 'G' and SentUserId = " + ourid + " and TookUserId = " + targetid;
        }
        else if (buttontype == "4")     //Engelle
        {
            command_text = "exec IgnoreUser " + ourid + ", " + targetid;
        }
        else if (buttontype == "2")     //Arkadaşlık teklif et
        {
            command_text = "exec SendFriendshipInvite " + ourid + ", " + targetid;
        }
        else return "true";
        List<MessageYaz> durum = new List<MessageYaz>();
        using (SqlConnection conn = new SqlConnection())
        {
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["Baglanti"].ConnectionString;
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = command_text; cmd.Connection = conn;
                conn.Open(); cmd.ExecuteNonQuery(); conn.Close(); conn.Dispose();
            }
        }
        return "true";
    }

    public class BildirimMiktari
    {
        public string friendshipnotifcount { get; set; }
        public string privatemessagecount { get; set; }
    }

    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static BildirimMiktari GetNotificationsCount(string id)
    {
        BildirimMiktari miktar = new BildirimMiktari() { friendshipnotifcount = "", privatemessagecount = "" };
        using (SqlConnection conn = new SqlConnection())
        {
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["Baglanti"].ConnectionString;
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = "exec FriendshipNotificationsCount " + id;
                cmd.Connection = conn; conn.Open();
                using (SqlDataReader oku = cmd.ExecuteReader())
                {
                    while (oku.Read())
                    {
                        miktar.friendshipnotifcount = "+" + oku["Okunmayanlar"].ToString();
                        miktar.privatemessagecount = "+" + oku["Mesajlar"].ToString();
                    }
                }
                conn.Close(); conn.Dispose();
            }
        }
        if (miktar.friendshipnotifcount == "+0") miktar.friendshipnotifcount = "";
        if (miktar.privatemessagecount == "+0") miktar.privatemessagecount = "";
        return miktar;
    }

    private static string SpanToExplain(TimeSpan _span)
    {
        string ret = "";
        if (_span.TotalDays > 1) { ret = ((int)_span.TotalDays).ToString() + " gün önce"; }
        else if (_span.TotalHours > 1) { ret = ((int)_span.TotalHours).ToString() + " saat önce"; }
        else if (_span.TotalMinutes > 1) { ret = ((int)_span.TotalMinutes).ToString() + " dakika önce"; }
        else if (_span.TotalSeconds > 1) { ret = ((int)_span.TotalSeconds).ToString() + " saniye önce"; }
        return ret;
    }

    public class ArkadaslikBildirim
    {
        public string UserId { get; set; }
        public string NotificationMessage { get; set; }
        public string RelationTime { get; set; }
        public string RelationSeen { get; set; }
    }

    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static List<ArkadaslikBildirim> GetRelationNotifications(string id)
    {
        List<ArkadaslikBildirim> satirListesi = new List<ArkadaslikBildirim>();
        using (SqlConnection conn = new SqlConnection())
        {
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["Baglanti"].ConnectionString;
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = "exec FriendshipNotifications " + id;
                cmd.Connection = conn;
                conn.Open();
                using (SqlDataReader oku = cmd.ExecuteReader())
                {
                    while (oku.Read())
                    {
                        ArkadaslikBildirim liste = new ArkadaslikBildirim();
                        liste.UserId = oku["UserId"].ToString();
                        liste.NotificationMessage = oku["NotificationMessage"].ToString();
                        liste.RelationTime = SpanToExplain(DateTime.Now - DateTime.Parse(oku["RelationTime"].ToString()));
                        liste.RelationSeen = oku["RelationSeen"].ToString().Replace(" ", "");
                        satirListesi.Add(liste);
                    }
                }
                conn.Close(); conn.Dispose();
            }
        }
        return satirListesi;
    }

    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static List<ArkadaslikBildirim> GetMessageNotifications(string id)
    {
        List<ArkadaslikBildirim> satirListesi = new List<ArkadaslikBildirim>();
        using (SqlConnection conn = new SqlConnection())
        {
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["Baglanti"].ConnectionString;
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = "select SentUserId, (select nickname from Users where id = SentUserId) as NickName, count(SentUserId) as MessageCount from PrivateTalkings where TookUserId = " + id + " and Seen = 'H' group by SentUserId";
                cmd.Connection = conn;
                conn.Open();
                using (SqlDataReader oku = cmd.ExecuteReader())
                {
                    while (oku.Read())
                    {
                        ArkadaslikBildirim liste = new ArkadaslikBildirim();
                        liste.UserId = oku["SentUserId"].ToString();
                        liste.NotificationMessage = oku["NickName"].ToString() + " size " + oku["MessageCount"].ToString() + " adet mesaj gönderdi";
                        liste.RelationTime = "(Bu sayfada konuşamazsınız)";
                        liste.RelationSeen = "H";
                        satirListesi.Add(liste);
                    }
                }
                conn.Close(); conn.Dispose();
            }
        }
        return satirListesi;
    }

    public class ProfilBilgileri
    {
        public string nickname { get; set; }
        public string gender { get; set; }
        public string picture { get; set; }
        public string recstatus { get; set; }
        public string register { get; set; }
        public string isonline { get; set; }
        public string menuint { get; set; }
        public string message { get; set; }
    }

    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static ProfilBilgileri GetProfileData(string userid, string targetid)
    {
        ProfilBilgileri bilgiler = new ProfilBilgileri();
        using (SqlConnection conn = new SqlConnection())
        {
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["Baglanti"].ConnectionString;
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = "exec ProfileMenuInteger " + userid + ", " + targetid;
                cmd.Connection = conn;
                conn.Open();
                using (SqlDataReader oku = cmd.ExecuteReader())
                {
                    while (oku.Read())
                    {
                        bilgiler.nickname = oku["nickname"].ToString();
                        bilgiler.gender = oku["gender"].ToString();
                        bilgiler.picture = oku["picture"].ToString();
                        bilgiler.recstatus = oku["recstatus"].ToString().Replace(" ", "");
                        DateTime regdate = DateTime.Parse(oku["register_date"].ToString());
                        TimeSpan _span = DateTime.Now - regdate;
                        bilgiler.register = SpanToExplain(_span) + " kayıt oldu";
                        DateTime lin = DateTime.Parse(oku["login_time"].ToString());
                        DateTime lout = DateTime.Parse(oku["logout_time"].ToString());
                        if (lin > lout) bilgiler.isonline = "1";
                        else bilgiler.isonline = "0";
                        bilgiler.menuint = oku["menuint"].ToString();
                        bilgiler.message = oku["profilemessage"].ToString();
                    }
                }
                conn.Close(); conn.Dispose();
            }
        }
        if (bilgiler.recstatus == "B") bilgiler.nickname = "...";
        return bilgiler;
    }

    public class Kullanicilar
    {
        public string id { get; set; }
        public string userid { get; set; }
        public string nickName { get; set; }
        public string gender { get; set; }
        public string picture { get; set; }
        public string recstatus { get; set; }
    }

    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static List<Kullanicilar> GetFriendsList(string userid)
    {
        List<Kullanicilar> satirListesi = new List<Kullanicilar>();
        using (SqlConnection conn = new SqlConnection())
        {
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["Baglanti"].ConnectionString;
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = "exec FriendsList " + userid;
                cmd.Connection = conn;
                conn.Open();
                using (SqlDataReader oku = cmd.ExecuteReader())
                {
                    while (oku.Read())
                    {
                        Kullanicilar liste = new Kullanicilar();
                        liste.userid = oku["FriendId"].ToString();
                        liste.nickName = oku["nickname"].ToString();
                        liste.gender = oku["gender"].ToString();
                        liste.picture = oku["picture"].ToString();
                        satirListesi.Add(liste);
                    }
                }
                conn.Close(); conn.Dispose();
            }
        }
        return satirListesi;
    }
}