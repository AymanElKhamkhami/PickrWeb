<%@ Page Title="Default Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Pickr._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .controls {
            margin-top: 10px;
            border: 1px solid transparent;
            border-radius: 3px 3px 3px 3px;
            box-sizing: border-box;
            -moz-box-sizing: border-box;
            height: 32px;
            outline: none;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
        }

        #searchStart, #searchDest {
            background-color: #fff;
            font-weight: 300;
            padding: 11px 11px 11px 13px;
            text-overflow: ellipsis;
            width: 300px;
        }

         #searchStart{
         }
        #searchDest {
            margin-left: 12px;
        }

        #searchStart:focus, #searchDest:focus {
                border-color: #4d90fe;
            }

    </style>


    <%--<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>--%>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBlkwFwPg7dV6fpe_IzEtiPYdnao45B4nY&language=en&libraries=drawing,places,geometry"></script>
    <script src="https://cdn.rawgit.com/bjornharrtell/jsts/gh-pages/1.0.2/jsts.min.js"></script>


    <script type="text/javascript">

        var directionsDisplay;
        var directionsService = new google.maps.DirectionsService();

        function initialize() {

            var lodz = new google.maps.LatLng(51.7592, 19.4560);

            var defaultBounds = new google.maps.LatLngBounds(
                new google.maps.LatLng(51.850789, 19.251971),
                new google.maps.LatLng(51.706244, 19.617801));
            var options = { bounds: defaultBounds };

            // Search Start
            var searchStart = (document.getElementById('<%=searchStart.ClientID%>'));
            var autocomplete = new google.maps.places.Autocomplete(searchStart, options);

            autocomplete.setComponentRestrictions({ country: "pl" });
            google.maps.event.addListener(autocomplete, 'place_changed', function () {});

            // Search Destination
            var searchDest = (document.getElementById('<%=searchDest.ClientID%>'));
            var autocomplete2 = new google.maps.places.Autocomplete(searchDest, options);

            autocomplete2.setComponentRestrictions({ country: "pl" });
            google.maps.event.addListener(autocomplete2, 'place_changed', function () { });

        }//intialiaze end


        google.maps.event.addDomListener(window, 'load', initialize);


    </script>


    <h2>Looking for a ride?</h2>

    <div class="container" style="padding-left:0px;">
        <div class="navbar-collapse collapse" style="padding:0px">
            <ul class="nav navbar-nav">
                <li>
                    <input runat="server" type="text" id="searchStart" class="form-control" style="border-bottom-right-radius:0px; border-top-right-radius:0px; " placeholder="Start point" onFocus="geolocate()"></input>
                    
                </li>
                <li>
                    <input runat="server" type="text" id="searchDest" class="form-control" style="border-radius:0px;" placeholder="Destination" onFocus="geolocate()"></input>
                </li>
                <li>
                    <asp:Button runat="server" ID="SearchRide" Text="Search" CssClass="btn btn-primary" style="border-bottom-left-radius:0px; border-top-left-radius:0px;" OnClick="SearchRide_Click" />
                </li>
            </ul>
        </div>
    </div>


    <asp:Label ID="test" runat="server"></asp:Label>
    
    <div class="jumbotron">
        <img src="/Images/Pickr_Logo2.png" alt="Pickr." height="120" border="0">
        <p class="lead" style="margin-top:10px;">Pickr is your social club for searching and offering car rides in your city.</p>
        <p><a href="~/About" class="btn btn-primary btn-lg">Find out more &raquo;</a></p>
    </div>

    <div class="row">
        <div class="col-md-4">
            <h2>Getting started</h2>
            <p>
                ASP.NET Web Forms lets you build dynamic websites using a familiar drag-and-drop, event-driven model.
            A design surface and hundreds of controls and components let you rapidly build sophisticated, powerful UI-driven sites with data access.
            </p>
            <p>
                <a class="btn btn-default" href="http://go.microsoft.com/fwlink/?LinkId=301948">Learn more &raquo;</a>
            </p>
        </div>
        <div class="col-md-4">
            <h2>Get more libraries</h2>
            <p>
                NuGet is a free Visual Studio extension that makes it easy to add, remove, and update libraries and tools in Visual Studio projects.
            </p>
            <p>
                <a class="btn btn-default" href="http://go.microsoft.com/fwlink/?LinkId=301949">Learn more &raquo;</a>
            </p>
        </div>
        <div class="col-md-4">
            <h2>Web Hosting</h2>
            <p>
                You can easily find a web hosting company that offers the right mix of features and price for your applications.
            </p>
            <p>
                <a class="btn btn-default" href="http://go.microsoft.com/fwlink/?LinkId=301950">Learn more &raquo;</a>
            </p>
        </div>
    </div>

    
</asp:Content>
