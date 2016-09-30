<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="shortcut icon" type="image/x-icon" href="images/profile.png" />
    <title>ChatPoint</title>
    <style>

        .login{
            width:400px;;
            margin-top:15%; 
            border:thin;
        }

        span {
            font-family:Papyrus; font-size:18px;
            text-shadow:2px 2px 3px #808080;
        }

        .txtKullaniciAd{ 
            position:center;
            width:25%; height:25px;
            border-radius:15px; text-align:center; padding:5px;
            font-family:Papyrus; font-size:24px;
            text-shadow:2px 2px 3px #808080;
            color:#f53b1a; min-width:300px;
        }

        .txtKullaniciSifre{ 
            position:center;
            margin-top:8px; width:25%; height:25px;
            border-radius:15px; text-align:center;
            padding:5px; font-family:Papyrus;
            font-size:24px; text-shadow:2px 2px 3px #808080;
            color:#f53b1a; min-width:300px;
        } 
        
        #btn_giris{
            margin-top:10px;
            width:150px;
            height:25px;
            border-radius:10px 0px 10px 0px;
        }

        #btn_giris{
            margin-top:10px;
            width:100px;
            height:100px;
            border:none;
            background:url(images/login.png);
            background-size:contain;
        }

        #btn_Kaydol{
            margin-top:10px;
            width:100px;
            height:100px;
            border:none;
            background:url(images/register.png);
            background-size:contain;
        }

        #btn_sifremi_unuttum{
            margin-top:10px;
            width:100px;
            height:100px;
            border:none;
            background:url(images/question.png);
            background-size:contain;
        }
    </style>
    <script>
        function BodyOnLoad() {
            document.oncontextmenu = new Function("return false;");
        }
    </script>
    <script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
</head>
<body onload="BodyOnLoad" style="-ms-user-select:none;-moz-user-select:none;-webkit-user-select:none;user-select:none;">
    <form id="form1" runat="server">
    <div id="main" style="width:100%;height:100%">
        <center>
            <div id="login" class="login">
                <input type="text" class="txtKullaniciAd" placeholder="Kullanıcı Adınızı Giriniz" id="txt_userid" runat="server"/><br />
                <input type="password" class="txtKullaniciSifre" id="txt_password" runat="server" placeholder="Şifrenizi Giriniz"/><br />
                <div style="width:420px;height:150px;">
                    <div style="float:left;width:130px;height:140px;"><asp:Button ID="btn_giris" runat="server" OnClick="btn_giris_Click"/><span>Giriş</span></div>
                    <div style="float:left;width:130px;height:140px;"><asp:Button ID="btn_Kaydol" runat="server" OnClick="btn_Kaydol_Click" /><span>Kayıt</span></div>
                    <div style="float:left;width:130px;height:140px;"><asp:Button ID="btn_sifremi_unuttum" runat="server" OnClick="btn_sifremi_unuttum_Click"/><span>Şifremi Unuttum</span></div><br />
                </div>
                <br />
                <div><input type="checkbox" runat="server" id="check_beni_hatirla" /><span>Beni Hatırla</span></div>
                <br />
                <asp:Label ID="lbl_error" runat="server"></asp:Label>
            </div>
        </center>
    </div>
    </form>
</body>
</html>
