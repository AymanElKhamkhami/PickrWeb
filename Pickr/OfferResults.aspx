<%@ Page Title="Search Results" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OfferResults.aspx.cs" Inherits="Pickr.OfferResults" %>

<%@ Register Src="~/Account/OpenAuthProviders.ascx" TagPrefix="uc" TagName="OpenAuthProviders" %>
<%@ Import Namespace="Pickr.Classes" %>
<%@ Import Namespace="Pickr.Models" %>


<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">

    <%--<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/jquery-ui.min.js"></script>

    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>--%>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBlkwFwPg7dV6fpe_IzEtiPYdnao45B4nY&language=en&libraries=drawing,places,geometry"></script>
    <script src="https://cdn.rawgit.com/bjornharrtell/jsts/gh-pages/1.0.2/jsts.min.js"></script>


    <style>
        .iconbutton {
            color: #2C3E50;
            cursor: pointer;
            cursor: hand;
            font-size: x-large;
            text-decoration: none;
        }

        .warning .iconbutton {
            color: #2C3E50 !important;
            cursor: pointer !important;
            cursor: hand !important;
            font-size: x-large !important;
            text-decoration: none !important;
        }

        .iconbutton:hover {
            color: #1A242F;
            text-decoration: none;
        }

        .warning .iconbutton:hover {
            color: #1A242F !important;
            text-decoration: none !important;
        }

        .modal {
            text-align: center;
            padding: 0 !important;
        }

            .modal:before {
                content: '';
                display: inline-block;
                height: 100%;
                vertical-align: middle;
                margin-right: -4px;
            }

        .modal-dialog {
            display: inline-block;
            text-align: left;
            vertical-align: middle;
        }
    </style>


    <script type="text/javascript">


        var directionsDisplay;
        var directionsService = new google.maps.DirectionsService();

        var waypoints = [];
        var start;
        var end;

        var markersCount = 0;
        var startMarker;
        var destinationMarker;
        var waypointMarker;

        var duration;

        var results = [];

        <%for (var i = 0; i < ((List<Offer>)HttpContext.Current.Session["Results"]).Count; i++)
        {%>

        var str = [];
        var dst = [];
        var wpts = [];
        var id;

        id = <%=((List<Offer>)HttpContext.Current.Session["Results"])[i].OfferId%>;

        str.push('<%=((List<Offer>)HttpContext.Current.Session["Results"])[i].Start.lat%>');
        str.push('<%=((List<Offer>)HttpContext.Current.Session["Results"])[i].Start.lng%>');
        dst.push('<%=((List<Offer>)HttpContext.Current.Session["Results"])[i].Destination.lat%>');
        dst.push('<%=((List<Offer>)HttpContext.Current.Session["Results"])[i].Destination.lng%>');

        <%for (var j = 0; j < ((List<Offer>)HttpContext.Current.Session["Results"])[i].Waypoints.Count; j++)
        {%>

        var wpt = [];
        wpt.push('<%=((List<Offer>)HttpContext.Current.Session["Results"])[i].Waypoints[j].lat%>');
        wpt.push('<%=((List<Offer>)HttpContext.Current.Session["Results"])[i].Waypoints[j].lng%>');
        wpts.push(wpt);

        <%}%>

        var ofr = [];
        ofr.push(str);
        ofr.push(dst);
        ofr.push(wpts);
        ofr.push(id);

        results.push(ofr);

        <%}%>

        console.log(JSON.stringify(results));
        console.log(results);

        function initialize(offId) {


            var lodz = new google.maps.LatLng(51.7592, 19.4560);

            var mapOptions = {
                zoom: 12,
                minZoom: 11,
                center: lodz,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                mapTypeControl: false,
                streetViewControl: false,
                draggable: false
            };

            var map = new google.maps.Map(document.getElementById('googleMap'), mapOptions);

            directionsDisplay = new google.maps.DirectionsRenderer({
                draggable: false,
                map: map
            });

            directionsDisplay.setMap(map);
            directionsDisplay.setOptions({ suppressMarkers: true }); // To remove the direction default pins A and B
            directionsDisplay.setPanel(document.getElementById("directionsPanel")); //??????????????


            
            var wypts = [];

            for (var i=0; i< results.length; i++)//--------------------------------------------------------------------
            {
                if(results[i][3] == offId) {

                    var lat = results[i][0][0];
                    var lng = results[i][0][1];
                    start = new google.maps.LatLng(lat, lng);

                    lat = results[i][1][0];
                    lng = results[i][1][1];
                    end = new google.maps.LatLng(lat, lng);


                    for (var j = 0; j < results[i][2].length; j++) {
                        lat = results[i][2][j][0];
                        lng = results[i][2][j][1];
                        var pos = new google.maps.LatLng(lat, lng);
                        wypts.push(pos);
                    }
                }
            }

            


            for (var i = 0; i < wypts.length; i++) {
                waypoints.push({
                    location: wypts[i],
                    stopover: true
                });
            }


            console.log(JSON.stringify(waypoints));

            placeMarker(start, map, 1);
            markersCount++;
            placeMarker(end, map, 2);
            markersCount++;

            if (wypts.length > 0) {
                for (var i = 0; i < wypts.length; i++) {
                    placeMarker(waypoints[i].location, map, markersCount + 1);
                    markersCount++;
                }
            }


            calcRoute(start, waypoints, end);


            // Place a marker on the map
            function placeMarker(position, map, index) {

                var infowindow;
                var geocoder;

                //Show coordinates of any place marker in console
                console.log("lat: " + position.lat() + " lng: " + position.lng());

                // If the first marker is added
                if (index == 1) {

                    startMarker = new google.maps.Marker({
                        position: position,
                        map: map,
                        draggable: false,
                        title: 'Start',
                        animation: google.maps.Animation.BOUNCE,
                        icon: '/Images/start_pin.png',
                        cursor: 'crosshair'
                    });



                    // Marker click listener: Open infowindow showing place info
                    infowindow = new google.maps.InfoWindow();
                    geocoder = new google.maps.Geocoder;

                    google.maps.event.addListener(startMarker, 'click', function () {

                        var placeID;

                        //Places Library to retrieve the place name
                        var service = new google.maps.places.PlacesService(map);

                        // Geocode library to retrieve the place address
                        geocoder.geocode({ 'location': startMarker.getPosition() }, function (results, status) {
                            if (status === google.maps.GeocoderStatus.OK) {
                                if (results[0]) {

                                    placeID = results[0].place_id;

                                    service.getDetails({
                                        placeId: placeID
                                    }, function (place, status) {
                                        infowindow.setContent('<div><strong>' + place.name + '</strong></br>' + place.formatted_address);
                                        startMarker.infowindow = infowindow;
                                        infowindow.open(map, startMarker);
                                    });

                                }
                            }
                        });
                    });

                }

                    // If the second marker is added
                else if (index == 2) {
                    destinationMarker = new google.maps.Marker({
                        position: position,
                        map: map,
                        draggable: false,
                        title: 'Destination',
                        animation: google.maps.Animation.BOUNCE,
                        icon: '/Images/destination_pin.png',
                        cursor: 'crosshair'
                    });


                    // Marker click listener: Open infowindow showing place info
                    infowindow = new google.maps.InfoWindow();
                    geocoder = new google.maps.Geocoder;

                    google.maps.event.addListener(destinationMarker, 'click', function () {

                        var placeID;

                        //Places Library to retrieve the place name
                        var service = new google.maps.places.PlacesService(map);

                        // Geocode library to retrieve the place address
                        geocoder.geocode({ 'location': destinationMarker.getPosition() }, function (results, status) {
                            if (status === google.maps.GeocoderStatus.OK) {
                                if (results[0]) {

                                    placeID = results[0].place_id;

                                    service.getDetails({
                                        placeId: placeID
                                    }, function (place, status) {
                                        infowindow.setContent('<div><strong>' + place.name + '</strong></br>' + place.formatted_address);
                                        destinationMarker.infowindow = infowindow;
                                        infowindow.open(map, destinationMarker);
                                    });

                                }
                            }
                        });
                    });
                }


                    // If other markers are added
                else {

                    waypointMarker = new google.maps.Marker({
                        position: position,
                        map: map,
                        draggable: false,
                        title: 'Waypoint',
                        opacity: 0,
                        cursor: 'crosshair'
                    });

                    var temp;



                    // Marker click listener: Open infowindow showing place info
                    infowindow = new google.maps.InfoWindow();
                    geocoder = new google.maps.Geocoder;

                    google.maps.event.addListener(waypointMarker, 'click', function () {

                        var placeID;

                        //Places Library to retrieve the place name
                        var service = new google.maps.places.PlacesService(map);

                        // Geocode library to retrieve the place address
                        geocoder.geocode({ 'location': waypointMarker.getPosition() }, function (results, status) {
                            if (status === google.maps.GeocoderStatus.OK) {
                                if (results[0]) {

                                    placeID = results[0].place_id;

                                    service.getDetails({
                                        placeId: placeID
                                    }, function (place, status) {
                                        infowindow.setContent('<div><strong>' + place.name + '</strong></br>' + place.formatted_address);
                                        waypointMarker.infowindow = infowindow;
                                        infowindow.open(map, waypointMarker);
                                    });

                                }
                            }
                        });
                    });

                }

                //map.panTo(position);

            }//placeMarker end

            function calcRoute(start, waypoints, end) {

                var request = {
                    origin: startMarker.getPosition(),
                    destination: destinationMarker.getPosition(),
                    waypoints: waypoints,
                    optimizeWaypoints: true,
                    travelMode: google.maps.TravelMode.DRIVING
                };

                directionsService.route(request, function (response, status) {
                    if (status == google.maps.DirectionsStatus.OK) {
                        directionsDisplay.setDirections(response);
                        directionsDisplay.setMap(map);

                        var myroute = response.routes[0];

                        // Getting the coordinates array of the route nodes
                        var routeNodes = [];

                        var legs = myroute.legs;
                        for (i = 0; i < legs.length; i++) {
                            var steps = legs[i].steps;
                            for (j = 0; j < steps.length; j++) {
                                var path = steps[j].path;
                                for (k = 0; k < path.length; k++) {
                                    routeNodes.push(path[k]);
                                    //placeMarker(path[k], map, 3);
                                }
                            }
                        }

                        console.log("route nodes:\n" + JSON.stringify(routeNodes));
                        console.log("number of nodes:\n" + routeNodes.length);



                        // Calculating the route distance and duration
                        var totalDist = 0;
                        var totalTime = 0;

                        for (i = 0; i < myroute.legs.length; i++) {
                            totalDist += myroute.legs[i].distance.value;
                            totalTime += myroute.legs[i].duration.value;
                        }

                        duration = Math.floor(totalTime / 60);
                        var dist = (totalDist / 1000).toPrecision(2);
                        document.getElementById('distance').innerHTML = dist + " km";
                        document.getElementById('duration').innerHTML = duration + " mins";
                    }

                    else {
                        alert("Directions Request from " + startMarker.getPosition().toUrlValue(6) + " to " + destinationMarker.getPosition().toUrlValue(6) + " failed: " + status);
                    }
                });

            }//calcRoute end


            //var routeDetails = document.getElementById('routeDetails');
            //map.controls[google.maps.ControlPosition.TOP_RIGHT].push(routeDetails);


        }//intialiaze end



        function getOfferId(offId) {
            document.getElementById('<%=SelectedOffer.ClientID%>').value = offId;
        }


        //Dialog boxes---------------------------------------------------------------


        function minmax(value) {
            var table = document.getElementById('<%=offersList.ClientID%>');
            var max = table.rows[1].cells[3].innerHTML;

            if (parseInt(value) < 1)
                return 1;
            else if (parseInt(value) > max)
                return max;
            else return value;
        }

        $(document).ready(function () {

            //$("#requestInfo").hide();

            $(".open").click(function (e) {
                e.preventDefault();
                $("#requestInfo").fadeIn(300, function () { $(this).focus(); });
                var offId = $(this).closest('tr').find('td:eq(0)').text();
                getOfferId(offId);
            });

            $('.clsmodal').click(function () {
                $("#requestInfo").fadeOut(300);
                $("#mapInfo").fadeOut(300);
            });

            $(".info").click(function (e) {
                e.preventDefault();
                $("#mapInfo").fadeIn(300, function () { $(this).focus(); });
                var offId = $(this).closest('tr').find('td:eq(0)').text();
                initialize(offId);
                waypoints = [];
                markersCount = 0;
            });

        });





    </script>

    <h2 runat="server" id="Header">Ride Matches</h2>
    <asp:LinkButton runat="server" ID="Notify" Visible="false">Get notified for matching offers in the future?</asp:LinkButton>

    <p class="text-danger">
        <asp:Literal runat="server" ID="ErrorMessage" />
    </p>

    <%--    <asp:LinkButton runat="server" class="fa fa-trash fa-2x iconbutton"></asp:LinkButton>
    <i class="fa fa-trash fa-2x iconbutton"></i>--%>


    <asp:Table runat="server" ID="offersList" CssClass="table table-striped table-hover "></asp:Table>


    <div id="mapInfo" class="modal fade in" style="display: block; padding-right: 17px; background-color: rgba(0, 0, 0, 0.4);" tabindex="-1">
        <script type="text/javascript">$("#mapInfo").hide();</script>
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close clsmodal" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Driver's path</h4>
                </div>
                <div class="modal-body">
                    <div id="wrapper" style="position: relative;">
                        <div id="googleMap" class="jumbotron" style="height: 300px; margin-top: 0px; margin-bottom:0px;"></div>
                        
                        <div id="routeDetails" style="position: absolute; top: 10px; right: 10px; z-index: 99;">
                            <ul style="margin: 0; padding: 0px 10px 0px 10px; list-style: none; background-color: rgba(44,62,80,0.1); border-radius: 3px;">
                                <li style="display: inline-block;">
                                    <i class="fa fa-arrows-h fa-2x" aria-hidden="true" style="margin: 5px 0px 5px 0px; vertical-align: middle; font-size: large;"></i>
                                    <i style="vertical-align: middle;">&nbsp;</i>
                                    <i id="distance" style="vertical-align: middle; font-style: normal; font-size: small;">--</i>
                                </li>
                                <li style="display: inline-block;">
                                    <label>&nbsp;&nbsp;&nbsp;</label>
                                </li>
                                <li style="display: inline-block;">
                                    <!--<span class="glyphicon glyphicon-time"></span>-->
                                    <i class="fa fa-clock-o fa-2x" aria-hidden="true" style="margin: 5px 0px 5px 0px; vertical-align: middle; font-size: large;"></i>
                                    <i style="vertical-align: middle;">&nbsp;</i>
                                    <i id="duration" style="vertical-align: middle; font-style: normal; font-size: small;">--</i>
                                </li>
                            </ul>
                        </div>
                    </div>


                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger btn-sm clsmodal" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>




    <div id="requestInfo" class="modal fade in" style="display: block; padding-right: 17px; padding-top: 10%; background-color: rgba(0, 0, 0, 0.4);" tabindex="-1">
        <script type="text/javascript">$("#requestInfo").hide();</script>
        <div class="modal-dialog modal-sm">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close clsmodal" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Request information</h4>
                </div>
                <div class="modal-body">
                    <p>Choose your required number of seats</p>
                    <asp:TextBox runat="server" ID="Seats" CssClass="form-control input-sm" TextMode="Number" Text="1" onchange="this.value = minmax(this.value)" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="Seats" CssClass="text-danger" ErrorMessage="The number of seats must be specified." Display="Dynamic" /></br>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger btn-sm clsmodal" data-dismiss="modal">Cancel</button>
                    <asp:HiddenField runat="server" ID="SelectedOffer" />
                    <asp:Button runat="server" ID="Send" Text="Send request" CssClass="btn btn-primary btn-sm" UseSubmitBehavior="false" OnClick="Send_Click" />
                </div>
            </div>
        </div>
    </div>

</asp:Content>
