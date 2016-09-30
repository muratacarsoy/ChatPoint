using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class ChatPage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            string kullaniciID = null, roomId = null;
            if (Session["userid"] == null || Session["id"] == null) { Response.Redirect("~/ChatRooms.aspx"); return; }
            if (Request.QueryString["uid"] != null)
            {
                kullaniciID = Request.QueryString["uid"].ToString();
                hidden_userid.Value = kullaniciID; hidden_id.Value = Session["id"].ToString();
                if (Session["userid"].ToString() != kullaniciID) { Response.Redirect("~/ChatRooms.aspx"); return; }
            }
            if (Request.QueryString["rid"] != null)
            {
                roomId = Request.QueryString["rid"].ToString();
                hidden_roomid.Value = roomId;
            }
            if (roomId != null && kullaniciID != null)
            {
                SqlConnection baglan = new SqlConnection(ConfigurationManager.ConnectionStrings["Baglanti"].ConnectionString);
                baglan.Open();
                SqlCommand ActiveRoomAdd = new SqlCommand("update Users set active_room_id=" + roomId + 
                    " where userid='" + kullaniciID + "'", baglan);
                ActiveRoomAdd.ExecuteNonQuery();
                baglan.Close(); baglan.Dispose();
            }
            else { Response.Redirect("~/ChatRooms.aspx"); }
        }
        catch (Exception) { }
    }

    public class MessageYaz { public string msg { get; set; } }

    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string SendText(string userid, string roomid, string message)
    {
        if (message == "") return "true";
        List<MessageYaz> durum = new List<MessageYaz>();
        using (SqlConnection conn = new SqlConnection())
        {
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["Baglanti"].ConnectionString;
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = "declare @datetime datetime = getdate() insert into Talkings (SentUserId, RoomId, MessageText, MessageTime) values ('" +
                    userid + "'," + roomid + ",'" + message.Replace("'", "").Replace("<", "").Replace(">", "") +"', @datetime)";
                cmd.Connection = conn;
                conn.Open(); cmd.ExecuteNonQuery();
                conn.Close(); conn.Dispose();
            }
        }
        return "true";
    }

    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static string SendPrivateText(string sentid, string tookid, string message)
    {
        if (message == "") return "true";
        List<MessageYaz> durum = new List<MessageYaz>();
        using (SqlConnection conn = new SqlConnection())
        {
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["Baglanti"].ConnectionString;
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = "declare @datetime datetime = getdate() insert into PrivateTalkings(SentUserId, TookUserId, MessageText, MessageTime, Seen) values (" + sentid +
                    ", " + tookid + ", '" + message.Replace("'", "").Replace("<", "").Replace(">", "") + "', @datetime, 'H')";
                cmd.Connection = conn; conn.Open(); cmd.ExecuteNonQuery(); conn.Close(); conn.Dispose();
            }
        }
        return "true";
    }

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

    public class Konusmalar
    {
        public string id { get; set; }
        public string sendUser { get; set; }
        public string nickName { get; set; }
        public string messageText { get; set; }
        public string messageTime { get; set; }
    }

    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static List<Konusmalar> GetText(string roomid)
    {
        List<Konusmalar> satirListesi = new List<Konusmalar>();
        using (SqlConnection conn = new SqlConnection())
        {
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["Baglanti"].ConnectionString;
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = "select id, (select nickname from Users where Talkings.SentUserId = Users.userid) as NickName, SentUserId, MessageText, MessageTime from Talkings where RoomId = " + roomid + " order by id";
                cmd.Connection = conn; conn.Open();
                using (SqlDataReader oku = cmd.ExecuteReader())
                {
                    while (oku.Read())
                    {
                        Konusmalar liste = new Konusmalar();                       
                        liste.sendUser = oku["SentUserId"].ToString();
                        liste.nickName = oku["NickName"].ToString();
                        liste.messageText = oku["MessageText"].ToString();
                        liste.id=oku["id"].ToString();
                        DateTime messageDateTime = DateTime.Parse(oku["MessageTime"].ToString());
                        TimeSpan span = DateTime.Now - messageDateTime;
                        liste.messageTime = SpanToExplain(span);
                        satirListesi.Add(liste);
                    }
                }
                conn.Close(); conn.Dispose();
            }
        }
        return satirListesi;
    }

    public class Mesajlar
    {
        public string id { get; set; }
        public string sentuserid { get; set; }
        public string tookuserid { get; set; }
        public string sentusernick { get; set; }
        public string tookusernick { get; set; }
        public string messageText { get; set; }
        public string messageTime { get; set; }
        public string seen { get; set; }
    }

    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static List<Mesajlar> GetPrivateMessages(string user_id, string private_user_id)
    {
        List<Mesajlar> satirListesi = new List<Mesajlar>();
        using (SqlConnection conn = new SqlConnection())
        {
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["Baglanti"].ConnectionString;
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = "exec GetPrivateTalkings " + user_id + ", " + private_user_id;
                cmd.Connection = conn; conn.Open();
                using (SqlDataReader oku = cmd.ExecuteReader())
                {
                    while (oku.Read())
                    {
                        Mesajlar liste = new Mesajlar();
                        liste.id = oku["id"].ToString();
                        liste.sentuserid = oku["SentUserId"].ToString();
                        liste.tookuserid = oku["TookUserId"].ToString();
                        liste.sentusernick = oku["SentUserNick"].ToString();
                        liste.tookusernick = oku["TookUserNick"].ToString();
                        liste.messageText = oku["MessageText"].ToString();
                        DateTime messageDateTime = DateTime.Parse(oku["MessageTime"].ToString());
                        TimeSpan span = DateTime.Now - messageDateTime;
                        liste.messageTime = SpanToExplain(span);
                        liste.seen = oku["seen"].ToString();
                        satirListesi.Add(liste);
                    }
                }
                conn.Close(); conn.Dispose();
            }
        }
        return satirListesi;
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
    public static List<Kullanicilar> GetUsers(string roomid)
    {
        List<Kullanicilar> satirListesi = new List<Kullanicilar>();
        using (SqlConnection conn = new SqlConnection())
        {
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["Baglanti"].ConnectionString;
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = "select id, userid, gender, picture, nickname, recstatus from Users where active_room_id = " + 
                    roomid + " and login_time > logout_time";
                cmd.Connection = conn;
                conn.Open();
                using (SqlDataReader oku = cmd.ExecuteReader())
                {
                    while (oku.Read())
                    {
                        Kullanicilar liste = new Kullanicilar();
                        liste.id = oku["id"].ToString();
                        liste.userid = oku["userid"].ToString();
                        liste.nickName = oku["nickname"].ToString();
                        liste.gender = oku["gender"].ToString();
                        liste.picture = oku["picture"].ToString();
                        liste.recstatus = oku["recstatus"].ToString();
                        satirListesi.Add(liste);
                    }
                }
                conn.Close(); conn.Dispose();
            }
        }
        return satirListesi;
    }

    [System.Web.Services.WebMethodAttribute(), System.Web.Script.Services.ScriptMethodAttribute()]
    public static List<Kullanicilar> JustPrivateUser(string sentid, string tookid)
    {
        List<Kullanicilar> satirListesi = new List<Kullanicilar>();
        using (SqlConnection conn = new SqlConnection())
        {
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["Baglanti"].ConnectionString;
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = "select id, userid, gender, picture, nickname, recstatus from Users where id = " +
                    sentid + " or id = " + tookid;
                cmd.Connection = conn;
                conn.Open();
                using (SqlDataReader oku = cmd.ExecuteReader())
                {
                    while (oku.Read())
                    {
                        Kullanicilar liste = new Kullanicilar();
                        liste.id = oku["id"].ToString();
                        liste.userid = oku["userid"].ToString();
                        liste.nickName = oku["nickname"].ToString();
                        liste.gender = oku["gender"].ToString();
                        liste.picture = oku["picture"].ToString();
                        liste.recstatus = oku["recstatus"].ToString();
                        satirListesi.Add(liste);
                    }
                }
                conn.Close(); conn.Dispose();
            }
        }
        return satirListesi;
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
                        liste.RelationTime = "(Özel konuşmak için tıklayın)";
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
}
