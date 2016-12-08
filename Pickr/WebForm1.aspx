<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="Pickr.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <link href="http://localhost:8081/Content/bootstrap.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBlkwFwPg7dV6fpe_IzEtiPYdnao45B4nY&language=en&libraries=drawing,places,geometry"></script>
    <script src="https://cdn.rawgit.com/bjornharrtell/jsts/gh-pages/1.0.2/jsts.min.js"></script>


    <script type="text/javascript">

        var directionsDisplay;
        var directionsService = new google.maps.DirectionsService();

        function initialize() {

            var lodz = new google.maps.LatLng(51.7592, 19.4560);

            var mapOptions = {
                zoom: 12,
                minZoom: 11,
                center: lodz,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                mapTypeControl: false,
                streetViewControl: false//,
            }

            var map = new google.maps.Map(document.getElementById('googleMap'), mapOptions);


        }//intialiaze end


        google.maps.event.addDomListener(window, 'load', initialize);


    </script>

    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>


            <div id="googleMap" class="jumbotron" style="height: 500px; width:500px; margin:100px; padding:0px; border-radius:50px;"></div>

        </div>
    </form>
</body>
</html>
