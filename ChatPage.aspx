<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChatPage.aspx.cs" Inherits="ChatPage" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Chat Sayfası</title>
    <link rel="shortcut icon" type="image/x-icon" href="images/profile.png" />
    <style>
        #main { width: 100%; height: 600px; }
        #ust_menu { width: 100%; height: 50px; }
        #arkadas_icon { width: 50px; }
        #offline_gorusme { width: 50px; }
        #refresh { width: 50px; }
        #back { width: 50px; }
        #logout { width: 50px; }

        #div_friendship_requests::-webkit-scrollbar-thumb {
            border-radius: 10px; background-color: #FFF;
            background-image: -webkit-gradient(linear, 40% 0%, 75% 84%, from(#1da4c3), to(#1862a1), color-stop(.6,#2b748d));
        }
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

        .div_notification {
            margin:5px; width:86%; height:auto;
            border-radius:10px; cursor:pointer;
            background-color:rgba(216, 238, 255, 0.90);
        }
        .div_notification .notification_userid { display:none; }

        #tbl { width:70%;background-color:gray;overflow-y:scroll;float:left;height:100%;border-radius:20px 0px 0px 20px; transform: scaleY(-1);background-image:url(images/background.jpg); }

        #tbl::-webkit-scrollbar-thumb {
            border-radius: 10px; background-color: #FFF;
            background-image: -webkit-gradient(linear, 40% 0%, 75% 84%, from(#1da4c3), to(#1862a1), color-stop(.6,#2b748d));
        }

        #tbl::-webkit-scrollbar { border-radius: 10px; width: 12px; background-color: rgba(245, 245, 245, 0); }
        #tbl::-webkit-scrollbar-track {
            -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.2); background-color: rgba(255, 255, 255, 0.3); border-radius: 10px; }

        #div_users { width:28%;overflow-y:scroll;float:left;height:100%;overflow-x:hidden; }
        #div_users::-webkit-scrollbar-thumb {
            border-radius: 10px; background-color: #FFF;
            background-image: -webkit-gradient(linear, 40% 0%, 75% 84%, from(#1da4c3), to(#1862a1), color-stop(.6,#2b748d)); }
        #div_users::-webkit-scrollbar { border-radius: 10px; width: 12px; background-color: rgba(245, 245, 245, 0); }
        #div_users::-webkit-scrollbar-track {
            -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.2); background-color: rgba(255, 255, 255, 0.3); border-radius: 10px; }

        #friends_list::-webkit-scrollbar-thumb {
            border-radius: 10px; background-color: #FFF;
            background-image: -webkit-gradient(linear, 40% 0%, 75% 84%, from(#1da4c3), to(#1862a1), color-stop(.6,#2b748d)); }
        #friends_list::-webkit-scrollbar { border-radius: 10px; width: 12px; background-color: rgba(245, 245, 245, 0); }
        #friends_list::-webkit-scrollbar-track {
            -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.2); background-color: rgba(255, 255, 255, 0.3); border-radius: 10px; }

        .konusma-balonu-me { margin:12px; background-color: #25B0B9; float: right;
            padding: 10px 20px; border-radius: 5px; position: relative; color: white; }

        .konusma-balonu-me:after {
            content: ''; position: absolute; right: 30px;
            bottom: -18px; border-style: solid;
            border-top-width: 20px; border-right-width: 15px; border-left-width: 15px;
            border-top-color: #25B0B9; border-right-color: transparent;
            border-bottom-color: transparent; border-left-color: transparent;
        }

        .konusma-balonu-other {
            margin:12px; background-color:#2C7A20; float: left; padding: 10px 20px;
            border-radius: 5px; position: relative; color: white;
        }

        .konusma-balonu-other:after {
            content: ''; position: absolute; left: 30px;
            bottom: -18px; border-style: solid;
            border-top-width: 20px; border-right-width: 15px; border-left-width: 15px;
            border-top-color: #2C7A20; border-right-color: transparent;
            border-bottom-color: transparent; border-left-color: transparent;
        }

        .out_div_dialog {
            width:100%; height:auto; display:block; overflow:hidden; font-family:Arial; font-size:12px;
            color:white; transform:scaleY(-1);
        }

        .div_dialog_me {
            margin:2px; float:right;
            height:100%; width:auto;
            cursor:pointer; max-width:60%;
        }

        .div_dialog_me:active .sub_dialog_date {
            display:block;
        }

        .div_dialog_other {
            margin:2px; float:left;
            height:100%; width:auto;
            cursor:pointer; max-width:60%;
        }

        .div_dialog_other:active .sub_dialog_date { display:block; }

        .sub_dialog_date { display:none; }

        .div_user_me {
            padding:3px;cursor:pointer; border-radius:20px;
            min-width:180px; min-height:40px;
            background-color:rgba(128, 128, 128, 0.30);
        }
        .div_user_me .div_user_img { margin:2px; float:left; width:32px; height:32px; }
        .div_user_me p { font:bold 12px arial, verdana; text-align:left; }
        .div_user_me .hidden_p { display:none; }
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

        #div_open_public {
            padding:3px;cursor:pointer;
            border-radius:20px;
            min-width:180px;
            min-height:40px;
            background-color:rgba(128, 0, 0, 0.30);
        }
        #div_open_public .div_user_img { margin:2px; float:left; width:32px; height:32px; }
        #div_open_public p { font:normal 12px arial, verdana; text-align:left; }

        .div_relation_button { float:left;margin:2%;width:120px;height:120px;border-radius:10px;background-color:rgba(255, 0, 255, 0.20);cursor:pointer; }
        .sub_span_rel_button { display:none; }
        #div_emojiler{
            padding:8px;height:100%;width:100%;border-radius:20px;border:none;background-color:rgba(255, 255, 255, 0.80);overflow-y:scroll;
        }
        #div_emojiler::-webkit-scrollbar-thumb {
            border-radius: 10px; background-color: #FFF;
            background-image: -webkit-gradient(linear, 40% 0%, 75% 84%, from(#1da4c3), to(#1862a1), color-stop(.6,#2b748d)); }
        #div_emojiler::-webkit-scrollbar { border-radius: 10px; width: 12px; background-color: rgba(245, 245, 245, 0); }
        #div_emojiler::-webkit-scrollbar-track {
            -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.2); background-color: rgba(255, 255, 255, 0.3); border-radius: 10px; }
        .div_emoci {
            float:left;margin:6px;width:24px;height:24px;cursor:pointer;
        }
        .div_emoci img{
            width:24px;
        }
        .img_emoci {
            width:24px;
        }
    </style>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            document.oncontextmenu = new Function("return false;");
            ark_menu = 0; prv_menu = 0; private_talk_id = -1; change_pub_prv = 0;
            picture_array = ["/user.png", "/young.png", "/red.png", "/gn.png", "/person.png", "/doctor.png", "/glass.png", "/clerk.png", "/teacher.png", "/sailor.png", "/photographer.png", "/chef.png", "/farmer.png"];
            emoc_table = [
                [/:\)/g, "smiling.png", ":)"], [/:j/g, "smile.png", ":j"], [/:d/gi, "happy-4.png", ":D"], [/:=/g, "happy-1.png", ":="], [/:\(/g, "sad.png", ":("], [/;.\(/g, "unhappy.png", ";.("],
                [/;\)/g, "wink.png", ";)"], [/:e/gi, "happy-3.png", ":e"], [/:l/gi, "confused.png", ":l"], [/:p/gi, "tongue-out.png", ":P"], [/:6/g, "tongue-out-1.png", ":6"], [/\[o/gi, "crying-1.png", "[o"],
                [/k-\(/gi, "crying.png", "K-("], [/:!/g, "secret.png", ":!"], [/:-\./g, "ill.png", ":-."], [/:,/g, "emoticons.png", ":,"], [/:]/g, "happy.png", ":]"], [/:\?/g, "suspicious.png", ":?"],
                [/-,-/g, "suspicious-1.png", "-,-"], [/8\)/g, "nerd.png", "8)"], [/\.v\./gi, "mad.png", ".v."], [/:@/g, "angry.png", ":@"], [/x-I/g, "angry-1.png", "x-I"], [/:s/gi, "confused-1.png", ":S"],
                [/:-\*/g, "kissing.png", ":-*"], [/:3/g, "happy-2.png", ":3"], [/:7/g, "smart.png", ":7"], [/:x/gi, "quiet.png", ":x"], [/\(:/g, "ninja.png", "(:"], [/:-\$/g, "embarrassed.png", ":-$"],
                [/\*v\*/g, "in-love.png", "*v*"], [/\*_\*/g, "surprised.png", "*_*"], [/;-o/gi, "surprised-1.png", ";-o"], [/3-./g, "bored-2.png", "3-."], [/\^o\^/gi, "bored-1.png", "^o^"], [/-o-/gi, "bored.png", "-o-"]
            ];
            var div_emoc = document.getElementById('div_emojiler');
            var div_emoc_inner = ''; var regexp = '';
            for (var j = 0; j < emoc_table.length; j++) {
                div_emoc_inner = div_emoc_inner + '<div class="div_emoci"><img src="emoticons/' + emoc_table[j][1] + '" /><span style="display:none;">' + emoc_table[j][2] + '</span></div>';
            }
            div_emoc.innerHTML = div_emoc_inner;
            var text_msg = document.getElementById('text_message');
            var div_emoci_arr = div_emoc.getElementsByClassName('div_emoci');
            for (var j = 0; j < emoc_table.length; j++) {
                div_emoci_arr[j].addEventListener('click', function () {
                    var spans = this.getElementsByTagName('span');
                    text_msg.value = text_msg.value + spans[0].innerHTML;
                }, false);
            }
            setInterval(GetTextsAndUsers, 1000);
        });

        function place_emoci(str) {
            var ret = str;
            for (var j = 0; j < emoc_table.length; j++) {
                ret = ret.replace(emoc_table[j][0], '<img class="img_emoci" src="emoticons/' + emoc_table[j][1] + '" />');
            }
            return ret;
        }

        var change_pub_prv; var private_talk_id; var ark_menu; var picture_array; var emoc_table;
        function GetTextsAndUsers() {
            if (private_talk_id == -1) { GetText(); GetUsers(); }
            else { GetPrivateMessages(private_talk_id); JustPrivateUser(); }
            GetNotifications();
        }

        function arkadasClick() {
            var im = document.getElementById('arkadaslik_istekleri');
            var dv = document.getElementById('div_friendship_requests');
            dv.style.left = im.style.left;
            dv.style.top = im.style.bottom;
            if (prv_menu == 1) privateClick();
            if (ark_menu == 0) { dv.style.visibility = 'visible'; ark_menu = 1; GetRelationNotifications(); }
            else { dv.style.visibility = 'hidden'; ark_menu = 0; }
        };

        var prv_menu;
        function privateClick() {
            var im = document.getElementById('offline_gorusme');
            var dv = document.getElementById('div_private_chats');
            dv.style.left = im.style.left;
            dv.style.top = im.style.bottom;
            if (ark_menu == 1) arkadasClick();
            if (prv_menu == 0) { dv.style.visibility = 'visible'; prv_menu = 1; GetMessageNotifications(); }
            else { dv.style.visibility = 'hidden'; prv_menu = 0; }
        };

        function add_dialog_me(dialogtext) {
            var div_tbl = document.getElementById("tbl");
            div_tbl.innerHTML = "<div class=\"out_div_dialog\"><div class=\"div_dialog_me\">" +
                "<span class=\"konusma-balonu-me\"><b> " + dialogtext + " </b></span></div></div>" + div_tbl.innerHTML;
        }

        function add_dialog_other(nick, dialogtext) {
            var div_tbl = document.getElementById('tbl');
            div_tbl.innerHTML = '<div class="out_div_dialog"><div class="div_dialog_other">' +
                '<span class="konusma-balonu-other">' + '<b style="color:yellow">' + nick + ': </b>' + '<b> ' + dialogtext + ' </b></span></div></div>' + div_tbl.innerHTML;
        }

        function SendSomething() {
            if (private_talk_id == -1) { SendText(); }
            else { SendPrivateMessage(); }
        }

        function SendText() {
            var userid = document.getElementById("hidden_userid").value;
            var roomid = document.getElementById("hidden_roomid").value;
            var txt = document.getElementById("text_message").value;
            if (txt.length > 0) {
                if (txt.length < 3) { txt = txt + "___"; }
                if (txt.length < 120) {
                    $.ajax({
                        type: 'POST',
                        url: 'ChatPage.aspx/SendText',
                        data: '{"userid":"' + userid + '","roomid":"' + roomid + '","message":"' + txt + '"}',
                        contentType: 'application/json; charset=utf-8',
                        dataType: 'json',
                        success: function (msg) { },
                        error: function () { }
                    });
                } else {
                    alert('Mesajlarınız 120 karakterden az olmalıdır');
                }
                document.getElementById("text_message").value = "";
            }
        }

        function SendPrivateMessage() {
            var h_id = document.getElementById("hidden_id").value;
            var txt = document.getElementById("text_message").value;
            if (txt.length > 0) {
                if (txt.length < 3) { txt = txt + "___"; }
                if (txt.length < 120) {
                    $.ajax({
                        type: 'POST',
                        url: 'ChatPage.aspx/SendPrivateText',
                        data: '{"sentid":"' + h_id + '","tookid":"' + private_talk_id + '","message":"' + txt + '"}',
                        contentType: 'application/json; charset=utf-8',
                        dataType: 'json',
                        success: function (msg) { },
                        error: function () { }
                    });
                } else {
                    alert('Mesajlarınız 120 karakterden az olmalıdır');
                }
                document.getElementById("text_message").value = "";
            }
        }

        function GetText() {
            var div_tbl = document.getElementById('tbl');
            var userid = document.getElementById("hidden_userid").value;
            var roomid = document.getElementById("hidden_roomid").value;
            $.ajax({
                type: 'POST',
                url: 'ChatPage.aspx/GetText',
                data: '{"roomid":"' + roomid + '"}',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (msg) {
                    $.each(msg.d, function (i) {
                        var ids = document.getElementById("hidden_talkingIDs").value;
                        var ArrayIds = ids.split(',');
                        var kontrol='false';
                        for (var j = 0; j < ArrayIds.length; j++) {
                            if (ArrayIds[j] == this.id) { kontrol = 'true'; break; }
                        }
                        if (kontrol == 'false') {
                            if (this.sendUser == document.getElementById("hidden_userid").value) {
                                div_tbl.innerHTML = "<div class=\"out_div_dialog\"><div class=\"div_dialog_me\">" +
                                    "<span class=\"konusma-balonu-me\"> " + place_emoci(this.messageText) + " <sub class=\"sub_dialog_date\">" +
                                    this.messageTime + "</sub></span></div></div>" + div_tbl.innerHTML;
                            }
                            else {
                                div_tbl.innerHTML = '<div class="out_div_dialog"><div class="div_dialog_other">' +
                                    '<span class="konusma-balonu-other">' + '<b style="color:yellow">' + this.nickName + ': </b>' +
                                    place_emoci(this.messageText) + " <sub class=\"sub_dialog_date\">" + this.messageTime +
                                    "</sub></span></div></div>" + div_tbl.innerHTML;
                            }
                            document.getElementById("hidden_talkingIDs").value = ids + ',' + this.id;
                        }
                    });
                },
                error: function () {  }
            });
            if (change_pub_prv == 1) {
                if (private_talk_id == -1) { OpenPublicTalk(); }
                else { OpenPrivateTalk(private_talk_id); }
                change_pub_prv = 0;
            }
        }

        function GetPrivateMessages(prv_id) {
            var div_tbl = document.getElementById('tbl');
            var h_id = document.getElementById("hidden_id").value;
            $.ajax({
                type: 'POST',
                url: 'ChatPage.aspx/GetPrivateMessages',
                data: '{"user_id":"' + h_id + '", "private_user_id":"' + prv_id + '"}',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (msg) {
                    $.each(msg.d, function (i) {
                        var ids = document.getElementById("hidden_talkingIDs").value;
                        var ArrayIds = ids.split(',');
                        var kontrol = 'false';
                        for (var j = 0; j < ArrayIds.length; j++) {
                            if (ArrayIds[j] == this.id) { kontrol = 'true'; break; }
                        }
                        if (kontrol == 'false') {
                            if (this.sentuserid == document.getElementById("hidden_id").value) {
                                div_tbl.innerHTML = "<div class=\"out_div_dialog\"><div class=\"div_dialog_me\">" +
                                    "<span class=\"konusma-balonu-me\"> " + place_emoci(this.messageText) + " <sub class=\"sub_dialog_date\">" +
                                    this.messageTime + "</sub></span></div></div>" + div_tbl.innerHTML;
                            }
                            else {
                                div_tbl.innerHTML = '<div class="out_div_dialog"><div class="div_dialog_other">' +
                                    '<span class="konusma-balonu-other">' + '<b style="color:yellow">' + this.sentusernick + ': </b>' +
                                    place_emoci(this.messageText) + " <sub class=\"sub_dialog_date\">" + this.messageTime +
                                    "</sub></span></div></div>" + div_tbl.innerHTML;
                            }
                            document.getElementById("hidden_talkingIDs").value = ids + ',' + this.id;
                        }
                    });
                },
                error: function () { }
            });
            if (change_pub_prv == 1) {
                if (private_talk_id == -1) { OpenPublicTalk(); }
                else { OpenPrivateTalk(private_talk_id); }
                change_pub_prv = 0;
            }
        }

        function GetUsers() {
            var div_users = document.getElementById('div_users');
            var userid = document.getElementById("hidden_userid").value;
            var roomid = document.getElementById("hidden_roomid").value;
            $.ajax({
                type: 'POST',
                url: 'ChatPage.aspx/GetUsers',
                data: '{"roomid":"' + roomid + '"}',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (msg) {
                    div_users.innerHTML = '';
                    $.each(msg.d, function (i) {
                        var gender = '';
                        if (this.gender == 'Bayan') { gender = 'female'; } else { gender = 'male'; }
                        if (this.userid == document.getElementById("hidden_userid").value) {
                            div_users.innerHTML = '<div id="div_user_me" class="div_user_me">' +
                                '<img src="' + gender + picture_array[parseInt(this.picture)] + '" class="div_user_img" />' +
                                '<p>' + this.nickName + '</p><p class="hidden_p">' + this.id + '</p></div>' + div_users.innerHTML;
                        }
                        else {
                            div_users.innerHTML = div_users.innerHTML +
                                '<div class="div_user_other">' +
                                '<img src="' + gender + picture_array[parseInt(this.picture)] + '" class="div_user_img" />' +
                                '<p>' + this.nickName + '</p><p class="hidden_p">' + this.id + '</p></div>';
                        }
                    });
                    var div_um = document.getElementById('div_user_me');
                    div_um.addEventListener('click', function () {
                        var hidden_id = this.getElementsByClassName('hidden_p')[0].innerHTML; ShowProfile(hidden_id);
                    }, false);
                    var div_ots = document.getElementsByClassName('div_user_other');
                    for (var j = 0; j < div_ots.length; j++) {
                        var div_ot = div_ots[j];
                        div_ot.addEventListener('click', function () {
                            var hidden_id = this.getElementsByClassName('hidden_p')[0].innerHTML; ShowProfile(hidden_id);
                        }, false);
                    }
                },
                error: function () { }
            });
        }

        function JustPrivateUser() {
            var div_users = document.getElementById('div_users');
            var h_id = document.getElementById("hidden_id").value;
            $.ajax({
                type: 'POST',
                url: 'ChatPage.aspx/JustPrivateUser',
                data: '{"sentid":"' + h_id + '", "tookid":"' + private_talk_id + '"}',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function (msg) {
                    div_users.innerHTML = '';
                    $.each(msg.d, function (i) {
                        var gender = '';
                        if (this.gender == 'Bayan') { gender = 'female'; } else { gender = 'male'; }
                        if (this.userid == document.getElementById("hidden_userid").value) {
                            div_users.innerHTML = div_users.innerHTML +
                                '<div id="div_user_me" class="div_user_me">' +
                                '<img src="' + gender + picture_array[parseInt(this.picture)] + '" class="div_user_img" />' +
                                '<p>' + this.nickName + '</p><p class="hidden_p">' + this.id + '</p></div>';
                        } else {
                            div_users.innerHTML = div_users.innerHTML + '<div class="div_user_other">' +
                                '<img src="' + gender + picture_array[parseInt(this.picture)] + '" class="div_user_img" />' +
                                '<p>' + this.nickName + '</p><p class="hidden_p">' + this.id + '</p></div>';
                        }
                    });
                    div_users.innerHTML = div_users.innerHTML + '<div id="div_open_public">' +
                        '<img src="images/friends.png" class="div_user_img" />' + '<p>Genel Konuşma</p></div>';
                    var div_op = document.getElementById('div_open_public');
                    div_op.addEventListener('click', function () {
                        change_pub_prv = 1;
                        OpenPublicTalk();
                    }, false);
                    var div_um = document.getElementById('div_user_me');
                    div_um.addEventListener('click', function () {
                        var hidden_id = this.getElementsByClassName('hidden_p')[0].innerHTML; ShowProfile(hidden_id);
                    }, false);
                    var div_ots = document.getElementsByClassName('div_user_other');
                    for (var j = 0; j < div_ots.length; j++) {
                        var div_ot = div_ots[j];
                        div_ot.addEventListener('click', function () {
                            var hidden_id = this.getElementsByClassName('hidden_p')[0].innerHTML; ShowProfile(hidden_id);
                        }, false);
                    }
                },
                error: function () { }
            });
        }

        function ShowProfile(id) {
            var h_id = document.getElementById("hidden_id").value;
            var out_div = document.getElementById('out_div_user_profile');
            out_div.style.visibility = 'visible';
            $.ajax({
                type: 'POST',
                url: 'ChatPage.aspx/GetProfileData',
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
                            '<span>Kabul Et</span><span class="sub_span_rel_button">64</span></div>'; menu_int = menu_int - 64; }
                    if (menu_int >= 32) {
                        buttons_inner = buttons_inner + '<div class="div_relation_button"><img src="images/refuse.png" style="position:center;width:100px;height:100px;" />' +
                            '<span>Reddet</span><span class="sub_span_rel_button">32</span></div>'; menu_int = menu_int - 32; }
                    if (menu_int >= 16) {
                        buttons_inner = buttons_inner + '<div class="div_relation_button"><img src="images/unfriend.png" style="position:center;width:100px;height:100px;" />' +
                            '<span>Arkadaşı Sil</span><span class="sub_span_rel_button">16</span></div>'; menu_int = menu_int - 16; }
                    if (menu_int >= 8) {
                        buttons_inner = buttons_inner + '<div class="div_relation_button"><img src="images/unignore.png" style="position:center;width:100px;height:100px;" />' +
                            '<span>Engeli Aç</span><span class="sub_span_rel_button">8</span></div>'; menu_int = menu_int - 8; }
                    if (menu_int >= 4) {
                        buttons_inner = buttons_inner + '<div class="div_relation_button"><img src="images/ignore.png" style="position:center;width:100px;height:100px;" />' +
                            '<span>Engelle</span><span class="sub_span_rel_button">4</span></div>'; menu_int = menu_int - 4; }
                    if (menu_int >= 2) {
                        buttons_inner = buttons_inner + '<div class="div_relation_button"><img src="images/addfriend.png" style="position:center;width:100px;height:100px;" />' +
                            '<span>Arkadaşı Ekle</span><span class="sub_span_rel_button">2</span></div>'; menu_int = menu_int - 2; }
                    if (menu_int >= 1) {
                        buttons_inner = buttons_inner + '<div class="div_relation_button"><img src="images/message.png" style="position:center;width:100px;height:100px;" />' +
                            '<span>Özel Konuş</span><span class="sub_span_rel_button">1</span></div>'; menu_int = menu_int - 1; }
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
                                change_pub_prv = 1;
                                OpenPrivateTalk(id);
                            }
                            else if (button_type == 128) {
                                rel_buttons.innerHTML = ''; rel_buttons.style.display = 'none';
                                var f_list = document.getElementById('friends_list'); f_list.innerHTML = ''; f_list.style.display = 'block';
                                $.ajax({
                                    type: 'POST', url: 'ChatPage.aspx/GetFriendsList',
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
                url: 'ChatPage.aspx/SendRelation',
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

        function YenidenYukle() {
            if (private_talk_id == -1) { OpenPublicTalk(); }
            else { OpenPrivateTalk(private_talk_id); }

        }

        function OpenPrivateTalk(prv_id) {
            private_talk_id = prv_id;
            var div_tbl = document.getElementById('tbl'); div_tbl.innerHTML = '';
            var div_users = document.getElementById('div_users'); div_users.innerHTML = '';
            var ids = document.getElementById("hidden_talkingIDs"); ids.value = '';
            HideProfile();
        }

        function OpenPublicTalk() {
            private_talk_id = -1;
            var div_tbl = document.getElementById('tbl'); div_tbl.innerHTML = '';
            var div_users = document.getElementById('div_users'); div_users.innerHTML = '';
            var ids = document.getElementById("hidden_talkingIDs"); ids.value = '';
        }

        function GetNotifications() {
            var friendshipnots = document.getElementById('friendship_notifications');
            var messagenots = document.getElementById('message_notifications');
            var id = document.getElementById("hidden_id").value;
            $.ajax({
                type: 'POST',
                url: 'ChatPage.aspx/GetNotificationsCount',
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
                type: 'POST', url: 'ChatPage.aspx/GetRelationNotifications',
                data: '{"id":"' + id + '"}',contentType: 'application/json; charset=utf-8',
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
                type: 'POST', url: 'ChatPage.aspx/GetMessageNotifications',
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
                            var hidden_id = this.getElementsByClassName('notification_userid')[0].innerHTML; OpenPrivateTalk(hidden_id); privateClick();
                        }, false);
                    }
                },
                error: function () { }
            });
        }
    </script>
    <script src="https://code.jquery.com/jquery-1.9.1.min.js"></script>
</head>
<body onload="GetText();" style="-ms-user-select:none;-moz-user-select:none;-webkit-user-select:none;user-select:none;">
    <form id="form1" runat="server">
    <center>
     <div id="main">
         <input type="hidden" id="hidden_id" name="hidden_id" runat="server" /><input type="hidden" id="hidden_userid" name="hidden_userid" runat="server" />
         <input type="hidden" id="hidden_nickname" name="hidden_nickname" runat="server" /><input type="hidden" id="hidden_roomid" runat="server" />
         <input type="hidden" runat="server" id="hidden_talkingIDs" /><input type="hidden" runat="server" id="hidden_usersIDs" />

            <div id="ust_menu" style="width:500px;height:10%;">
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
                <div id="div_back" style="width:100px;float:left;">
                    <a href="ChatRooms.aspx">
                    <img id="back" src="images/back.png" /></a>
                </div>
                <div id="div_logout" style="width:100px;float:left;">
                    <a href="Logout.aspx">
                    <img id="logout" src="images/logout.png" /></a>
                </div> 
            </div>
            <div id="div_dialogs" style="width:85%;height:65%;border-radius:20px;background:linear-gradient(#ababeb, #ffffff);">
                <div id="tbl"></div><div id="div_users"></div>
            </div>
            <div id="div_WriteText" style="width:85%;height:12%;border-radius:20px;background:linear-gradient(#ababeb, #ffffff)">
                <table style="height:100%;width:100%;">
                    <tr>
                        <td style="width:25%;"><textarea id="text_message" runat="server" style="padding:8px;height:100%;width:100%;border-radius:20px;border:none;background-color:rgba(255, 255, 255, 0.80)"></textarea></td>
                        <td style="width:10%;min-width:100px;"><input type="button" id="btn_send" runat="server" style="border-radius:50%;height:80px;width:80px;background:url(images/reply.png);background-size:contain;border:none;margin-left:16px;margin-right:16px;" onclick="SendSomething();" /></td>
                        <td style="width:30%;"><div id="div_emojiler"></div></td>
                    </tr>
                </table>
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
                        <div id="relation_buttons" style="display:normal;width:75%;height:90%;"></div>
                        <div id="friends_list" style="display:none;width:75%;height:90%;overflow-y:scroll;"></div>
                    </div>
                </div>
            </div>
            <asp:Label ID="lbl_error" runat="server"></asp:Label>
        </div>
        </center>
    </form>
</body>
</html>
