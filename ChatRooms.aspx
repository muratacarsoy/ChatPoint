<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChatRooms.aspx.cs" Inherits="ChatRooms" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="shortcut icon" type="image/x-icon" href="images/profile.png" />
    <title>Chat Odaları</title>
        <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDw-MV_47H9_MQdAMjc4vJkLgNvYLPaFQs&callback=initMap"
        type="text/javascript"></script>
        <style>

        #main{ width:100%; height:600px; }
        #ust_menu{ width:100%; height:50px; }
        #arkadas_icon{ width:50px; }
        #offline_gorusme { width:50px; }
        #refresh { width:50px; }
        #profile { width: 50px; }
        #logout { width: 50px; }
        .div_notification {
            margin:5px; width:86%; height:auto;
            border-radius:10px; cursor:pointer;
            background-color:rgba(216, 238, 255, 0.90);
        }
        .div_notification .notification_userid { display:none; }
        #div_friendship_requests::-webkit-scrollbar-thumb {
            border-radius: 10px;
            background-color: #FFF;
            background-image: -webkit-gradient(linear, 40% 0%, 75% 84%, from(#1da4c3), to(#1862a1), color-stop(.6,#2b748d)); }
        #div_friendship_requests::-webkit-scrollbar { border-radius: 10px; width: 12px; background-color: rgba(245, 245, 245, 0); }
        #div_friendship_requests::-webkit-scrollbar-track {
            -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.2); background-color: rgba(255, 255, 255, 0.3); border-radius: 10px; }
        #div_private_chats::-webkit-scrollbar-thumb {
            border-radius: 10px; background-color: #FFF;
            background-image: -webkit-gradient(linear, 40% 0%, 75% 84%, from(#1da4c3), to(#1862a1), color-stop(.6,#2b748d));
        }
        #div_private_chats::-webkit-scrollbar { border-radius: 10px; width: 12px; background-color: rgba(245, 245, 245, 0); }
        #div_private_chats::-webkit-scrollbar-track {
            -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.2); background-color: rgba(255, 255, 255, 0.3); border-radius: 10px; }

        #friends_list::-webkit-scrollbar-thumb {
            border-radius: 10px; background-color: #FFF;
            background-image: -webkit-gradient(linear, 40% 0%, 75% 84%, from(#1da4c3), to(#1862a1), color-stop(.6,#2b748d)); }
        #friends_list::-webkit-scrollbar { border-radius: 10px; width: 12px; background-color: rgba(245, 245, 245, 0); }
        #friends_list::-webkit-scrollbar-track {
            -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.2); background-color: rgba(255, 255, 255, 0.3); border-radius: 10px; }
        .div_user_other {
            padding:3px;cursor:pointer;
            border-radius:20px;
            min-width:180px;
            min-height:40px;
            background-color:rgba(128, 0, 0, 0.30);
        }
        .div_user_other .div_user_img { margin:2px; float:left; width:32px; height:32px; }
        .div_user_other p { font:normal 12px arial, verdana; text-align:left; }
        .div_user_other .hidden_p { display:none; }
        .tr{
            width:99%; min-height:100px;
            border:solid; border-color:#404040;
            border-radius:20px; border-width:0px;
            background:linear-gradient(rgba(216, 200, 200, 0.4), rgba(255, 255, 255, 0.4)); }

        .tr:hover { border-width:1px;
            background:linear-gradient(rgba(216, 200, 200, 0.8), rgba(255, 255, 255, 0.8)); }

        .a_room_link { text-decoration:none; }
        .td { float:left; width:30%; }
        .td b { font-family:Papyrus; font-size:20px; }
        .map_link{ float:left; }
        .room_map{ width:110px; height:100px; }
         
        .div_relation_button { float:left;margin:2%;width:120px;height:120px;border-radius:10px;background-color:rgba(255, 0, 255, 0.20);cursor:pointer; }
        .sub_span_rel_button { display:none; }
        #lbl_totalonlineusersquantity { font-family:Papyrus; font-size:20px; }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script type="text/javascript">

        function FirstOpening() {
            document.oncontextmenu = new Function("return false;");
            ark_menu = 0; prv_menu = 0;
            picture_array = ["/user.png", "/young.png", "/red.png", "/gn.png", "/person.png", "/doctor.png", "/glass.png", "/clerk.png", "/teacher.png", "/sailor.png", "/photographer.png", "/chef.png", "/farmer.png"];
            setInterval(GetTextsAndUsers, 1000);
        }
        function GetTextsAndUsers() {
            GetNotifications();
        }

        var ark_menu; var picture_array; var prv_menu;
        function arkadasClick() {
            var im = document.getElementById('arkadaslik_istekleri');
            var dv = document.getElementById('div_friendship_requests');
            dv.style.left = im.style.left;
            dv.style.top = im.style.bottom;
            if (prv_menu == 1) privateClick();
            if (ark_menu == 0) { dv.style.visibility = 'visible'; ark_menu = 1; GetRelationNotifications(); }
            else { dv.style.visibility = 'hidden'; ark_menu = 0; }
        };

        function privateClick() {
            var im = document.getElementById('offline_gorusme');
            var dv = document.getElementById('div_private_chats');
            dv.style.left = im.style.left;
            dv.style.top = im.style.bottom;
            if (ark_menu == 1) arkadasClick();
            if (prv_menu == 0) { dv.style.visibility = 'visible'; prv_menu = 1; GetMessageNotifications(); }
            else { dv.style.visibility = 'hidden'; prv_menu = 0; }
        };

        function GetNotifications() {
            var friendshipnots = document.getElementById('friendship_notifications');
            var messagenots = document.getElementById('message_notifications');
            var id = document.getElementById("hidden_id").value;
            $.ajax({
                type: 'POST',
                url: 'ChatRooms.aspx/GetNotificationsCount',
                data: '{"id":"' + id + '"}',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (msg) {
                    friendshipnots.innerHTML = msg.d.friendshipnotifcount;
                    messagenots.innerHTML = msg.d.privatemessagecount;
                },
                error: function () {
                    friendshipnots.innerHTML = 'x';
                }
            });
        }

        function GetRelationNotifications() {
            var div_nots = document.getElementById('div_friendship_requests');
            var id = document.getElementById("hidden_id").value;
            $.ajax({
                type: 'POST', url: 'ChatRooms.aspx/GetRelationNotifications',
                data: '{"id":"' + id + '"}', contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (msg) {
                    div_nots.innerHTML = '';
                    $.each(msg.d, function (i) {
                        var inner = '<div class="div_notification"><span class="notification_userid">' + this.UserId + '</span>';
                        if (this.RelationSeen == 'H') inner = inner + '<b>' + this.NotificationMessage + '</b>';
                        else inner = inner + this.NotificationMessage;
                        inner = inner + '<br><sub>' + this.RelationTime + '</sub>';
                        inner = inner + '</div>';
                        div_nots.innerHTML = inner + div_nots.innerHTML;
                    });
                    var div_nots_array = div_nots.getElementsByClassName('div_notification');
                    for (var j = 0; j < div_nots_array.length; j++) {
                        var div_not = div_nots_array[j];
                        div_not.addEventListener('click', function () {
                            var hidden_id = this.getElementsByClassName('notification_userid')[0].innerHTML; ShowProfile(hidden_id); arkadasClick();
                        }, false);
                    }
                },
                error: function () { }
            });
        }

        function GetMessageNotifications() {
            var div_nots = document.getElementById('div_private_chats');
            var id = document.getElementById("hidden_id").value;
            $.ajax({
                type: 'POST', url: 'ChatRooms.aspx/GetMessageNotifications',
                data: '{"id":"' + id + '"}', contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (msg) {
                    div_nots.innerHTML = '';
                    $.each(msg.d, function (i) {
                        var inner = '<div class="div_notification">';
                        if (this.RelationSeen == 'H') inner = inner + '<b>' + this.NotificationMessage + '</b>';
                        else inner = inner + this.NotificationMessage;
                        inner = inner + '<br><sub>' + this.RelationTime + '</sub>';
                        inner = inner + '</div>';
                        div_nots.innerHTML = inner + div_nots.innerHTML;
                    });
                },
                error: function () { alert('HATA'); }
            });
        }

        function ShowProfile(id) {
            var h_id = document.getElementById("hidden_id").value;
            var out_div = document.getElementById('out_div_user_profile');
            out_div.style.visibility = 'visible';
            $.ajax({
                type: 'POST', url: 'ChatRooms.aspx/GetProfileData',
                data: '{"userid":"' + h_id + '", "targetid":"' + id + '"}',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (msg) {
                    document.getElementById('p_profile_user_nick').innerHTML = "<b>" + msg.d.nickname + "</b>";
                    document.getElementById('sub_profile_user_register_time').innerHTML = msg.d.register;
                    var pic_ind = parseInt(msg.d.picture);
                    if (msg.d.gender == 'Bayan') {
                        document.getElementById('img_profile_user_gender').src = 'female' + picture_array[pic_ind];
                    } else {
                        document.getElementById('img_profile_user_gender').src = 'male' + picture_array[pic_ind];
                    }
                    var p_onl = document.getElementById('p_profile_user_online');
                    if (msg.d.isonline == '1') { p_onl.innerHTML = 'Çevrimiçi'; p_onl.style.color = 'green'; }
                    else { p_onl.innerHTML = 'Çevrimdışı'; p_onl.style.color = 'red'; }
                    var span_prf = document.getElementById('span_profile_message');
                    span_prf.innerHTML = msg.d.message;
                    var menu_int = parseInt(msg.d.menuint);
                    var buttons_inner = '';
                    if (menu_int >= 128) {
                        buttons_inner = buttons_inner + '<div class="div_relation_button"><img src="images/friends.png" style="position:center;width:100px;height:100px;" />' +
                            '<span>Arkadaşlarım</span><span class="sub_span_rel_button">128</span></div>'; menu_int = menu_int - 128; }
                    if (menu_int >= 64) {
                        buttons_inner = buttons_inner + '<div class="div_relation_button"><img src="images/accept.png" style="position:center;width:100px;height:100px;" />' +
                            '<span>Kabul Et</span><span class="sub_span_rel_button">64</span></div>'; menu_int = menu_int - 64;
                    }
                    if (menu_int >= 32) {
                        buttons_inner = buttons_inner + '<div class="div_relation_button"><img src="images/refuse.png" style="position:center;width:100px;height:100px;" />' +
                            '<span>Reddet</span><span class="sub_span_rel_button">32</span></div>'; menu_int = menu_int - 32;
                    }
                    if (menu_int >= 16) {
                        buttons_inner = buttons_inner + '<div class="div_relation_button"><img src="images/unfriend.png" style="position:center;width:100px;height:100px;" />' +
                            '<span>Arkadaşı Sil</span><span class="sub_span_rel_button">16</span></div>'; menu_int = menu_int - 16;
                    }
                    if (menu_int >= 8) {
                        buttons_inner = buttons_inner + '<div class="div_relation_button"><img src="images/unignore.png" style="position:center;width:100px;height:100px;" />' +
                            '<span>Engeli Aç</span><span class="sub_span_rel_button">8</span></div>'; menu_int = menu_int - 8;
                    }
                    if (menu_int >= 4) {
                        buttons_inner = buttons_inner + '<div class="div_relation_button"><img src="images/ignore.png" style="position:center;width:100px;height:100px;" />' +
                            '<span>Engelle</span><span class="sub_span_rel_button">4</span></div>'; menu_int = menu_int - 4;
                    }
                    if (menu_int >= 2) {
                        buttons_inner = buttons_inner + '<div class="div_relation_button"><img src="images/addfriend.png" style="position:center;width:100px;height:100px;" />' +
                            '<span>Arkadaşı Ekle</span><span class="sub_span_rel_button">2</span></div>'; menu_int = menu_int - 2;
                    }
                    if (menu_int >= 1) {
                        buttons_inner = buttons_inner + '<div class="div_relation_button"><img src="images/message.png" style="position:center;width:100px;height:100px;" />' +
                            '<span>Özel Konuş</span><span class="sub_span_rel_button">1</span></div>'; menu_int = menu_int - 1;
                    }
                    var rel_buttons = document.getElementById('relation_buttons');
                    rel_buttons.innerHTML = buttons_inner;
                    var div_rel_buts = document.getElementsByClassName('div_relation_button');
                    for (var j = 0; j < div_rel_buts.length; j++) {
                        var div_rel_but = div_rel_buts[j];
                        div_rel_but.addEventListener('click', function () {
                            var button_type = this.getElementsByClassName('sub_span_rel_button')[0].innerHTML;
                            var yes_no_question = ''; var yes_no_buttons = '';
                            yes_no_buttons = yes_no_buttons + '<div class="div_relation_button"><img src="images/accept.png" style="position:center;width:100px;height:100px;" />' +
                                '<span>Evet</span><span class="sub_span_rel_button">1</span></div>';
                            yes_no_buttons = yes_no_buttons + '<div class="div_relation_button"><img src="images/refuse.png" style="position:center;width:100px;height:100px;" />' +
                                '<span>Hayır</span><span class="sub_span_rel_button">0</span></div>';
                            if (button_type == 1) {
                                alert('Bu sayfada özel konuşma yapamazsınız');
                            } else if (button_type == 128) {
                                rel_buttons.innerHTML = ''; rel_buttons.style.display = 'none';
                                var f_list = document.getElementById('friends_list'); f_list.innerHTML = ''; f_list.style.display = 'block';
                                $.ajax({
                                    type: 'POST', url: 'ChatRooms.aspx/GetFriendsList',
                                    data: '{"userid":"' + h_id + '"}', contentType: 'application/json; charset=utf-8',
                                    dataType: 'json',
                                    success: function (msg) {
                                        $.each(msg.d, function (i) {
                                            var gender = '';
                                            if (this.gender == 'Bayan') { gender = 'female'; } else { gender = 'male'; }
                                            f_list.innerHTML = f_list.innerHTML +
                                                '<div class="div_user_other">' +
                                                '<img src="' + gender + picture_array[parseInt(this.picture)] + '" class="div_user_img" />' +
                                                '<p>' + this.nickName + '</p><p class="hidden_p">' + this.userid + '</p></div>';
                                        });
                                        var div_ots = f_list.getElementsByClassName('div_user_other');
                                        for (var j = 0; j < div_ots.length; j++) {
                                            var div_ot = div_ots[j];
                                            div_ot.addEventListener('click', function () {
                                                var hidden_id = this.getElementsByClassName('hidden_p')[0].innerHTML;
                                                f_list.style.display = 'none'; rel_buttons.style.display = 'block';
                                                ShowProfile(hidden_id);
                                            }, false);
                                        }
                                    },
                                    error: function () { }
                                });
                            } else if (button_type == 16) {
                                yes_no_question = 'Bu arkadaşınızı silmek istediğinize emin misiniz?';
                                rel_buttons.innerHTML = yes_no_buttons; span_prf.innerHTML = yes_no_question;
                                var div_rel_buts = document.getElementsByClassName('div_relation_button');
                                for (var k = 0; k < div_rel_buts.length; k++) {
                                    var div_rel_but = div_rel_buts[k];
                                    div_rel_but.addEventListener('click', function () {
                                        var answer = this.getElementsByClassName('sub_span_rel_button')[0].innerHTML;
                                        if (answer == 1) {
                                            SendRelation(button_type, id);
                                        } else {
                                            ShowProfile(id);
                                        }
                                    }, false);
                                }
                            } else if (button_type == 4) {
                                yes_no_question = 'Bu kişiyi engellemek istediğinize emin misiniz?';
                                rel_buttons.innerHTML = yes_no_buttons; span_prf.innerHTML = yes_no_question;
                                var div_rel_buts = document.getElementsByClassName('div_relation_button');
                                for (var k = 0; k < div_rel_buts.length; k++) {
                                    var div_rel_but = div_rel_buts[k];
                                    div_rel_but.addEventListener('click', function () {
                                        var answer = this.getElementsByClassName('sub_span_rel_button')[0].innerHTML;
                                        if (answer == 1) {
                                            SendRelation(button_type, id);
                                        } else {
                                            ShowProfile(id);
                                        }
                                    }, false);
                                }
                            } else { SendRelation(button_type, id); }
                        }, false);
                    }
                },
                error: function () { }
            });
        }

        function SendRelation(btn_type, userid) {
            var h_id = document.getElementById("hidden_id").value;
            $.ajax({
                type: 'POST',
                url: 'ChatRooms.aspx/SendRelation',
                data: '{"ourid":"' + h_id + '","targetid":"' + userid + '","buttontype":"' + btn_type + '"}',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (msg) { ShowProfile(userid); },
                error: function () { }
            });
            document.getElementById("text_message").value = "";
        }

        function HideProfile() {
            var out_div = document.getElementById('out_div_user_profile');
            out_div.style.visibility = 'hidden';
            document.getElementById('img_profile_user_gender').src = '';
            document.getElementById('p_profile_user_nick').innerHTML = "";
            document.getElementById('sub_profile_user_register_time').innerHTML = "";
            var p_onl = document.getElementById('p_profile_user_online'); p_onl.innerHTML = "";
            var rel_buttons = document.getElementById('relation_buttons'); rel_buttons.innerHTML = ""; rel_buttons.style.display = 'block';
            var f_list = document.getElementById('friends_list'); f_list.innerHTML = ''; f_list.style.display = 'none';
        }

        function ProfileBak() { var h_id = document.getElementById("hidden_id").value; ShowProfile(h_id); }

        function GpsBul() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function (p) { 
                    var mylat = p.coords.latitude;
                    var mylng = p.coords.longitude;
                    var i=1;
                    while (document.getElementById("lat"+i)!=null) {
                        var roomLat = parseFloat(document.getElementById("lat" + i).value.replace(',','.'));
                        var roomLng = parseFloat(document.getElementById("lng" + i).value.replace(',', '.'));
                        var R = 6378.16;
                        var dLat = deg2rad(roomLat - mylat);
                        var dLng = deg2rad(roomLng - mylng);
                        var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(deg2rad(mylat)) * Math.cos(deg2rad(roomLat)) * Math.sin(dLng / 2) * Math.sin(dLng / 2);
                        var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a)); 
                        var d = (R * c)*1000;
                        var dizi = d.toString().split('.');
                        document.getElementById("uzaklik_" + i).innerHTML = dizi[0] + " metre.";
                        i++;
                    }
                    function deg2rad(deg) { return deg*((3.141592653589793)/180) }
                });
            } else { alert("GPS Navigator desteklenmiyor"); }
        }

        function initMap() {
            var i = 1;
            while (document.getElementById("room_map" + i) != null) {
                var latVal = parseFloat(document.getElementById("lat" + i).value.replace(",", "."));
                var lngVal = parseFloat(document.getElementById("lng" + i).value.replace(",", "."));
                var latlng = new google.maps.LatLng(latVal, lngVal);
                var myOptions = {
                    zoom: 17,
                    center: latlng,
                    mapTypeId: google.maps.MapTypeId.SATELLITE,
                    draggable: false, zoomControl: false, scrollwheel: false, disableDoubleClickZoom: true
                };
                var map = new google.maps.Map(document.getElementById("room_map" + i), myOptions);
                i++;
            }
        }

        function YenidenYukle() { 
            $("#div_tbl").empty();
            var donen_divler = "";
            $.ajax({
                type: 'POST',
                url: 'ChatRooms.aspx/ChatOdalariniGetir',
                data: '{}',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (msg) {
                    $.each(msg.d, function (i) { donen_divler = donen_divler + this.satir; });
                    $("#div_tbl").append(donen_divler);
                    initMap();
                    GpsBul();
                },
                error: function () {
                    alert("Talep Sırasında Hata Oluştu!");
                }
            });
        }
        
    </script>
     <script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>

</head>
<body onload="GpsBul();initMap();FirstOpening();">
    <form id="form1" runat="server">
    <input type="hidden" id="hidden_id" name="hidden_id" runat="server" />
    <input type="hidden" id="my_lat" />
    <input type="hidden" id="my_lng" />
        <center>
            <div id="main">
                <div id="ust_menu" style="width:500px;height:10%;-ms-user-select:none;-moz-user-select:none;-webkit-user-select:none;user-select:none;">
                <div id="arkadaslik_istekleri" style="width:100px;float:left;cursor:pointer;">
                    <img id="arkadas_icon" src="images/friends.png" onclick="arkadasClick();" />
                    <sub id="sub_arkadas" style="color:red;font-size:x-large;font-size:14px;"><b id="friendship_notifications"></b></sub>
                    <div id="div_friendship_requests" style="visibility:hidden;position:absolute;left:100px; top: 100px;z-index:100000;width:300px;height:400px;border-radius:10px;margin:5px;background-color:rgba(91, 94, 128, 0.30);overflow-y:scroll;overflow-x:hidden;"></div>
                </div>
                <div id="offline_gorusmeler" style="width:100px;float:left;cursor:pointer;">
                    <img id="offline_gorusme" src="images/messages.png" onclick="privateClick();" />
                    <sub id="sub_mesaj" style="color:red;font-size:x-large;font-size:14px;"><b id="message_notifications"></b></sub>
                    <div id="div_private_chats" style="visibility:hidden;position:absolute;left:100px; top: 100px;z-index:100000;width:300px;height:400px;border-radius:10px;margin:5px;background-color:rgba(91, 94, 128, 0.30);overflow-y:scroll;overflow-x:hidden;"></div>
                </div>
                <div id="div_refresh" style="width:100px;float:left;cursor:pointer;">
                    <img id="refresh" src="images/refresh.png" onclick="YenidenYukle();" />
                </div> 
                <div id="div_profile" style="width:100px;float:left;cursor:pointer;">
                    <img id="profile" src="images/profile.png" onclick="ProfileBak();" />
                </div>
                <div id="div_logout" style="width:100px;float:left;">
                    <a href="Logout.aspx">
                    <img id="logout" src="images/logout.png" /></a>
                </div> 
                </div>
                <div id="div_rooms" style="width:85%;height:90%;border-radius:20px;background:linear-gradient(#ababeb, #ffffff);-ms-user-select:none;-moz-user-select:none;-webkit-user-select:none;user-select:none;">
                    <div id="div_tbl" class="tbl">
                        <asp:Repeater ID="rep_Rooms" runat="server">
                            <ItemTemplate>
                              <div class="tr">
                                  <div class="td"><b><%# Eval("link") %></b></div>
                                    <div class="td"><b><%# Eval("OnlineKisiSayisi") %></b></div>
                                    <div class="td">
                                    <a class="map_link" href="/RoomsMap.aspx?lat=<%# Eval("latitude") %>&lng=<%# Eval("longitude") %>">
                                        <div id="room_map<%# Eval("RoomId") %>" class="room_map"></div>

                                        <input type="hidden" id="<%# Eval("RoomId") %>" value="<%# Eval("latitude") %>-<%# Eval("longitude") %>" />

                                        <input id="lat<%# Eval("RoomId") %>" style="display:none" value="<%# Eval("latitude") %>" />
                                        <input id="lng<%# Eval("RoomId") %>" style="display:none" value="<%# Eval("longitude") %>" />

                                    </a>
                                    <div class="td"><span id="uzaklik_<%# Eval("RoomId") %>">1000m</span></div>

                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <div><div class="td"><asp:Label ID="lbl_totalonlineusersquantity" runat="server" Text="Online Kullanıcı : 0" Font-Bold="true"></asp:Label></div></div>

                    </div>
                    <div id="out_div_user_profile" style="visibility:hidden;position:absolute;left:0;top:0;width:100%;height:600px;background-color:rgba(0, 0, 0, 0.70);font:16px arial, verdana;-ms-user-select:none;-moz-user-select:none;-webkit-user-select:none;user-select:none;">
                        <div id="div_user_profile" style="position:center;width:600px;height:480px;background:radial-gradient(#9cd1dd,#FFF,#99cfd3);border-radius:20px;margin:20px;padding:20px;">
                            <div id="div_user_title" style="position:center;width:90%;height:128px;margin-left:4px;margin-right:4px;border-radius:10px;background-color:rgba(255, 255, 0, 0.20);">
                                <div style="position:relative;float:left;width:128px;height:128px;"><img id="img_profile_user_gender" src="https://cdn2.iconfinder.com/data/icons/rcons-user/32/male-shadow-circle-128.png" style="width:128px;height:128px;border-radius:5px;" /></div>
                                <div style="position:relative;float:left;width:320px;height:100%;">
                                    <span id="p_profile_user_nick"></span><br />
                                    <sub id="sub_profile_user_register_time"></sub><br />
                                    <span id="p_profile_user_online" style="float:right;color:red;"></span>
                                </div>
                                <div style="float:right;width:48px;height:48px;background:url(images/back.png);background-size:contain;cursor:pointer;" onclick="HideProfile();"></div>
                            </div>
                            <div id="div_profile_buttons" style="position:center;width:60%;height:300px;">
                                <div style="width:100%;height:20%;border-radius:10px;background-color:rgba(0, 255, 255, 0.20);"><span id="span_profile_message"></span></div>
                                <div id="relation_buttons" style="width:75%;height:90%;"></div>
                                <div id="friends_list" style="display:none;width:75%;height:90%;overflow-y:scroll;"></div>
                            </div>
                        </div>
                    </div>
                    <asp:Label ID="lbl_error" runat="server"></asp:Label>

                </div>
      
            </div>
        </center>
    </form>
</body>
</html>
