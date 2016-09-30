<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RoomsMap.aspx.cs" Inherits="RoomsMap" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDw-MV_47H9_MQdAMjc4vJkLgNvYLPaFQs&callback=initMap"
    type="text/javascript"></script>
    <link rel="shortcut icon" type="image/x-icon" href="images/profile.png" />
    <title>Harita</title>
    <style>
        #main { width:100%; height:600px; }
        #ust_menu { width: 100%; height: 50px; }
        #user { width: 50px; }
        #back { width: 50px; }
        #logout { width: 50px; }


    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="main">
            <asp:Repeater ID="rep_rooms" runat="server">
                <ItemTemplate>
                    <input id="rooms_data<%# Eval("RoomId") %>" style="display: none;" value="<%# Eval("RoomName") %>#<%# Eval("OnlineKisiSayisi") %>#<%# Eval("latitude") %>#<%# Eval("longitude") %>" />
                </ItemTemplate>
            </asp:Repeater>
            <div id="ust_menu" style="width:300px;height:10%;margin:0 auto;">
                <div id="div_user" style="width:100px;float:left;cursor:pointer;">
                    <img id="user" src="images/profile.png" />
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
            <script>
                var map; var userLatLng;
                function initMap() {
                    var centerLat = <%= query_lat%>;
                    var centerLng = <%= query_lng%>;
                    var latVal = 41.000000;
                    var lngVal = 29.000000;
                    var latlng = new google.maps.LatLng(latVal, lngVal);
                    var myOptions = {
                        zoom: 13,
                        center: latlng,
                        mapTypeId: google.maps.MapTypeId.SATELLITE,
                    };
                    var map = new google.maps.Map(document.getElementById("map"), myOptions);
                    if (navigator.geolocation) {
                        navigator.geolocation.getCurrentPosition(function (p) {
                            userLatLng = new google.maps.LatLng(p.coords.latitude, p.coords.longitude);
                            var markerUser = new google.maps.Marker({
                                position: userLatLng,
                                map: map,
                                title: "Siz",
                                icon: "https://cdn1.iconfinder.com/data/icons/unique-round-blue/93/user-48.png"
                            });
                        });
                        document.getElementById('div_user').addEventListener('click', function () {
                            map.setCenter(userLatLng);
                        }, false);
                    } else {
                        alert("GPS Navigator desteklenmiyor");
                    }
                    var i = 1;
                    while (document.getElementById("rooms_data" + i) != null) {
                        var data = document.getElementById("rooms_data" + i).value.split("#");
                        var markerTitle = data[0] + "\n" + data[1] + " kişi mevcut";
                        var markerLatLng = new google.maps.LatLng(parseFloat(data[2].replace(",", ".")),
                            parseFloat(data[3].replace(",", ".")));
                        var marker = new google.maps.Marker({
                            position: markerLatLng,
                            title: markerTitle,
                            icon: "https://cdn2.iconfinder.com/data/icons/flat-style-svg-icons-part-1/512/chat_talk_voice_bubble_phone-48.png"
                        });
                        marker.setMap(map);
                        i++;
                    }
                    map.setCenter(new google.maps.LatLng(centerLat, centerLng));
                }
            </script>
            <div id="map" style="width:80%;height:80%;margin:0 auto;"></div>
            <asp:Label ID="lbl_error" runat="server"></asp:Label>
        </div>
    </form>
</body>
</html>
