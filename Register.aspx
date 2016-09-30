<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="shortcut icon" type="image/x-icon" href="images/profile.png" />
    <title>Kayıt Ol</title>
    <style>

        .login{
            width:600px;
            margin-top:5%; 
            border:thin;
        }

        .txtKullaniciAd{ 
            width:300px;height:25px;border-radius:15px;text-align:center;
            padding:5px;font-family:Papyrus;font-size:25px;text-shadow:2px 2px 3px #808080;
            color:#f53b1a;
        }

        .txtKullaniciSifre{ 
            margin-top:8px;width:300px;height:25px;border-radius:15px;
            text-align:center;padding:5px;font-family:Papyrus;
            font-size:25px;text-shadow:2px 2px 3px #808080;color:#f53b1a;
        } 
        
        .btnGiris{ margin-top:10px;width:150px;height:25px;border-radius:10px 0px 10px 0px; }
        .option_gender { font-family:Papyrus;font-size:25px;text-shadow:2px 2px 3px #808080; }
        #btn_Kaydol {
            margin-top:10px;
            width:100px;
            height:100px;
            border:none;
            background:url(images/register.png);
            background-size:contain;
        }

        div span {
            font-family:Papyrus;font-size:15px;text-shadow:2px 2px 3px #808080;
        }

        #ChangePictureButton { width:90%;font-family:Papyrus;font-size:15px;text-shadow:2px 2px 3px #808080; background-color:#dcdcdc; border:none; }
    </style>
    <script type="text/javascript">

        var picture_index; var picture_array; var picture_gender;
        function BodyOnLoad() {
            document.oncontextmenu = new Function("return false;");
            picture_index = 0; picture_gender = "male";
            picture_array = ["/user.png", "/young.png", "/red.png", "/gn.png", "/person.png", "/doctor.png", "/glass.png", "/clerk.png", "/teacher.png", "/sailor.png", "/photographer.png", "/chef.png", "/farmer.png"];
            document.getElementById("ImageProfile").src = picture_gender + picture_array[picture_index];
        }

        function ChangeImage() {
            picture_index++; if (picture_index > 12) picture_index = 0;
            document.getElementById("ImageProfile").src = picture_gender + picture_array[picture_index]; SendImageData();
        }

        function BayanClicked() { picture_gender = "female"; document.getElementById("ImageProfile").src = picture_gender + picture_array[picture_index]; SendImageData(); }
        function BayClicked() { picture_gender = "male"; document.getElementById("ImageProfile").src = picture_gender + picture_array[picture_index]; SendImageData(); }
        function SendImageData() {
            document.getElementById('hidden_index').value = picture_index;
        }
    </script>
    <script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>

</head>
<body onload="BodyOnLoad();" style="-ms-user-select:none;-moz-user-select:none;-webkit-user-select:none;user-select:none;">
    <form id="form1" runat="server">
     <div id="main" style="width:100%;height:100%">
        <center>
            <div id="login" class="login">
                <div style="float:left;width:320px;height:auto;">
                    <input type="hidden" id="hidden_index" value="0" runat="server" />
                    <img src="images/edit.png" style="width:100px;height:100px;" />
                    <input type="email" class="txtKullaniciAd" placeholder="Mail Adresinizi Giriniz" id="txt_userid" runat="server" required/><br />
                    <input type="password" class="txtKullaniciSifre" id="txt_password" runat="server" placeholder="Şifrenizi Giriniz" required/>
                    <br />
                    <input type="password" class="txtKullaniciSifre" id="txt_passwordTekrar" runat="server" placeholder="Şifrenizi Tekrar Giriniz" required/>
                    <br />
                     <asp:Label ID="lbl_sifre_eslesmiyor" runat="server"></asp:Label>
                    <br />
                    <input type="text" class="txtKullaniciAd" placeholder="Rumuz Giriniz" id="txt_Rumuz" runat="server" required/><br />
                    <asp:RadioButton ID="bay" runat="server" GroupName="cinsiyet" onclick="BayClicked();" required /><span class="option_gender">Bay</span> &nbsp; <asp:RadioButton ID="bayan" runat="server" GroupName="cinsiyet" onclick="BayanClicked();" required/><span class="option_gender">Bayan</span>
                </div>
                <div style="float:left;width:150px;height:auto;margin-top:50px;">
                    <asp:Image ID="ImageProfile" runat="server" Width="120" Height="120" onclick="ChangeImage();"></asp:Image>
                    <span class="option_gender">Resim Seçin</span><br /><br />
                    <div style="float:left;width:130px;height:140px;"><asp:Button ID="btn_Kaydol" runat="server" OnClick="btn_Kaydol_Click"/><span>Kayıt Ol</span></div>
                </div>
                <asp:Label ID="lbl_error" runat="server"></asp:Label>
            </div>
        </center>
    </div>
    </form>
</body>
</html>
