<%@ Page Title="Ride offer" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OfferDetails.aspx.cs" Inherits="Pickr.OfferDetails" %>

<%@ Register Src="~/Account/OpenAuthProviders.ascx" TagPrefix="uc" TagName="OpenAuthProviders" %>
<%@ Import Namespace="Pickr.Classes" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">



    <%--<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/jquery-ui.min.js"></script>

    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>--%>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBlkwFwPg7dV6fpe_IzEtiPYdnao45B4nY&language=en&libraries=drawing,places,geometry"></script>
    <script src="https://cdn.rawgit.com/bjornharrtell/jsts/gh-pages/1.0.2/jsts.min.js"></script>

    <%--<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <link rel="stylesheet" href="/resources/demos/style.css">--%>

    <%--<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>--%>

    <style>
        .time {
            border: none;
            height: 20px;
            width: 25px;
            text-align: center;
            cursor: pointer;
        }

            .time:focus {
                outline: none !important;
                background-color: #F1F1F1 !important;
            }

        #save:focus {
            outline: none !important;
        }

        .time::-webkit-inner-spin-button {
            -webkit-appearance: none;
            width: 0px;
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

        var range;
        var distance = 100; //radius, not the route distance
        var duration;

        function initialize() {


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


            var lat = '<%=((Coordinates)HttpContext.Current.Session["StartCoords"]).lat%>';
            var lng = '<%=((Coordinates)HttpContext.Current.Session["StartCoords"]).lng%>';
            start = new google.maps.LatLng(lat, lng);

            lat = '<%=((Coordinates)HttpContext.Current.Session["DestCoords"]).lat%>';
            lng = '<%=((Coordinates)HttpContext.Current.Session["DestCoords"]).lng%>';
            end = new google.maps.LatLng(lat, lng);

            var wypts = [];

            <%for (var i = 0; i < ((List<Coordinates>)HttpContext.Current.Session["Waypoints"]).Count; i++)
        {%>
            lat = '<%=((List<Coordinates>)HttpContext.Current.Session["Waypoints"]).ElementAt(i).lat%>';
            lng = '<%=((List<Coordinates>)HttpContext.Current.Session["Waypoints"]).ElementAt(i).lng%>';
            var pos = new google.maps.LatLng(lat, lng);
            wypts.push(pos);
            <%}%>


            for (var i = 0; i < wypts.length; i++) {
                waypoints.push({
                    location: wypts[i],
                    stopover: true
                });
            }


            placeMarker(start, map, 1);
            markersCount++;
            placeMarker(end, map, 2);
            markersCount++;

            if (waypoints.length > 0) {
                for (var i = 0; i < waypoints.length; i++) {
                    placeMarker(waypoints[i].location, map, markersCount + 1);
                    markersCount++;
                }
            }

            distance = '<%=(int)HttpContext.Current.Session["Radius"]%>';
            document.getElementById('radius').innerHTML = distance + " m";

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
                        icon: '/Images/waypoint_pin.png',
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

            //var routeInfo;
            var polygone;
            function calcRoute(start, waypoints, end) {

                if (range != null)
                    range.setMap(null);

                if (polygone != null)
                    polygone.setMap(null);
                //routeInfo.close();
                //routeInfo = new google.maps.InfoBubble();

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


                        // Draw the polygon around the route
                        var overviewPathGeo = [];
                        for (var i = 0; i < routeNodes.length; i++) {
                            overviewPathGeo.push(
                                [routeNodes[i].lng(), routeNodes[i].lat()]
                            );
                        }

                        //var distance = 50;  //meters;
                        var geoInput = {
                            type: "LineString",
                            coordinates: overviewPathGeo
                        };
                        var geoReader = new jsts.io.GeoJSONReader();
                        var geoWriter = new jsts.io.GeoJSONWriter();
                        var geometry = geoReader.read(geoInput).buffer(distance / 111120);
                        var polygon = geoWriter.write(geometry);

                        var oLanLng = [];
                        var oCoordinates;
                        oCoordinates = polygon.coordinates[0];
                        for (i = 0; i < oCoordinates.length; i++) {
                            var oItem;
                            oItem = oCoordinates[i];
                            oLanLng.push(new google.maps.LatLng(oItem[1], oItem[0]));
                        }

                        range = new google.maps.Polygon({
                            paths: oLanLng,
                            map: map,
                            fillOpacity: 0.2,
                            fillColor: '#729e47',
                            strokeWeight: 0
                        });

                        range.setMap(map);


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
                        document.getElementById('<%=Distance.ClientID%>').value = dist;

                        document.getElementById('<%=Dur.ClientID%>').value = duration;
                    }

                    else {
                        alert("Directions Request from " + startMarker.getPosition().toUrlValue(6) + " to " + destinationMarker.getPosition().toUrlValue(6) + " failed: " + status);
                    }
                });

            }//calcRoute end


            var routeDetails = document.getElementById('routeDetails');
            map.controls[google.maps.ControlPosition.TOP_RIGHT].push(routeDetails);

            var routeRadius = document.getElementById('routeRadius');
            map.controls[google.maps.ControlPosition.TOP_LEFT].push(routeRadius);

            var editRoute = document.getElementById('<%=editRoute.ClientID%>');
            map.controls[google.maps.ControlPosition.BOTTOM_LEFT].push(editRoute);





        }//intialiaze end


        google.maps.event.addDomListener(window, 'load', initialize);


        function setDepartureTime() {

            var mydate = new Date();

            var h = document.getElementById('<%=hour.ClientID%>');
            var m = document.getElementById('<%=minute.ClientID%>');

            var sessionH = document.getElementById('<%=HiddenHour.ClientID%>').value;
            var sessionM = document.getElementById('<%=HiddenMinute.ClientID%>').value;

            if (sessionH != "" && sessionM != "") {
                h.value = sessionH;
                m.value = sessionM;
            }

            else {
                h.value = mydate.getHours() < 10 ? "0" + mydate.getHours() : mydate.getHours() + "";
                m.value = mydate.getMinutes() < 10 ? "0" + mydate.getMinutes() : mydate.getMinutes() + "";
            }

        }


        function setDepartureDate() {

            var mydate = new Date();
            var d = document.getElementById('<%=DepartureDate.ClientID%>');
            var sessionD = document.getElementById('<%=HiddenDate.ClientID%>').value;

            if (sessionD != "") {
                d.value = sessionD;
            }

        }


        function checkDecimal() {
            var pr = document.getElementById('<%=Price.ClientID%>').value;
            var ex = parseFloat(pr).toFixed(2);
            document.getElementById('<%=Price.ClientID%>').value = ex;
        }


        $(document).ready(function () {

            setDepartureDate();
            setDepartureTime();

            $('.checkbox').click(function (e) {
                if ($('#multipleCheck')[0].checked == false) {
                    $('#multipleCheck')[0].checked = true;
                    e.preventDefault();
                    $("#multipleInfo").fadeIn(300);
                    $(".depDate").multiDatesPicker();
                }
                    
                else if ($('#multipleCheck')[0].checked == true) {
                    location.reload();
                }
                    
            });


            $('.clsmodal').click(function () {
                $("#multipleInfo").fadeOut(300);
            });

        });

    </script>


    <h2 runat="server" id="detailsTitle">Plan a Journey</h2>
    <p class="text-danger">
        <asp:Literal runat="server" ID="ErrorMessage" />
    </p>

    <div class="row">
        <div class="col-md-7">
            <section id="loginForm">
                <div class="form-horizontal">
                    <hr />
                    <asp:ValidationSummary runat="server" CssClass="text-danger" />
                    <asp:Panel runat="server">
                        <div class="form-group">
                            <asp:Label runat="server" AssociatedControlID="DepartureDate" CssClass="col-md-2 control-label">Departure time</asp:Label>
                            <div class="col-md-10">

                                <i class="fa fa-calendar" aria-hidden="true" style="position: absolute; margin: 13px 0px 3px 15px; vertical-align: middle; font-size: larger;"></i>
                                <input runat="server" type="text" id="DepartureDate" class="form-control depDate" style="display: inline; padding-left: 40px;" >
                                <input runat="server" type="text" id="timeHolder" class="form-control" style="display: inline; margin-left: 10px; width: 110px; border-radius: 4px;" onfocus="getElementById('<%=hour.ClientID%>').select();" />
                                
                                <div style="position: absolute; right: 178px; top: 12px; z-index: 99; margin: auto;">
                                    <i class="fa fa-clock-o" aria-hidden="true" style="margin: 0px 5px 3px 0px; vertical-align: middle; font-size: larger;"></i>
                                    <input runat="server" type="number" min="0" max="23" value="09" class="time" id="hour" onclick="this.select(); var sheet = document.createElement('style'); sheet.innerHTML = '#hour {color=black;}'; this.appendChild(sheet);" onchange="if(parseInt(this.value,10)<10)this.value='0'+this.value; if(parseInt(this.value,10)>23)this.value=23; if(parseInt(this.value,10)<0)this.value='01';" />
                                    <label>:</label>
                                    <input runat="server" type="number" min="0" max="59" value="09" class="time" id="minute" onclick="this.select(); " onchange="if(parseInt(this.value,10)<10)this.value='0'+this.value; if(parseInt(this.value,10)>59)this.value=59; if(parseInt(this.value,10)<0)this.value='01';" />
                                </div>

                                <%--<asp:TextBox runat="server" ID="DepartureTime" CssClass="form-control" TextMode="DateTimeLocal" Width="50%" />--%>
                                <asp:HiddenField runat="server" ID="HiddenDate" />
                                <asp:HiddenField runat="server" ID="HiddenHour" />
                                <asp:HiddenField runat="server" ID="HiddenMinute" />

                                <div runat="server" id="checkMultiple" class="checkbox">
                                    <label id="multipleJourneys">
                                        <input type="checkbox" id="multipleCheck">
                                        Plan the same journey on mutiple dates
                                    </label>
                                </div>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="DepartureDate" CssClass="text-danger" ErrorMessage="Departure time is required." />
                            </div>
                        </div>
                        <div class="form-group">
                            <asp:Label runat="server" AssociatedControlID="Seats" CssClass="col-md-2 control-label">Number of seats</asp:Label>
                            <div class="col-md-10">
                                <asp:TextBox runat="server" ID="Seats" CssClass="form-control" TextMode="Number" Width="50%" />
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="Seats" CssClass="text-danger" ErrorMessage="The number of seats must be specified." /></br>
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="Seats" ErrorMessage="The number is not valid." ForeColor="Red" Display="Dynamic"
                        ValidationExpression="^[1-3]*$" ValidationGroup="NumericValidate">The number of seats should be between 1 and 3</asp:RegularExpressionValidator>
                            </div>
                        </div>
                        <div class="form-group">
                            <asp:Label runat="server" AssociatedControlID="Price" CssClass="col-md-2 control-label">Price (PLN)</asp:Label>
                            <div class="col-md-10">
                                <asp:TextBox runat="server" ID="Price" CssClass="form-control" TextMode="Number" Width="50%" />
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="Price"
                                    CssClass="text-danger" ErrorMessage="The price must be specified" /></br>
                    <asp:RegularExpressionValidator runat="server" ControlToValidate="Price" ErrorMessage="The number is not valid." ForeColor="Red" Display="Dynamic"
                        ValidationExpression="^[0-9][0-9]*$" ValidationGroup="NumericValidate">The price you entered is invalid</asp:RegularExpressionValidator>
                            </div>
                        </div>

                    </asp:Panel>
                    </br>
                    <div class="form-group">
                        <div class="col-md-offset-2 col-md-10">
                            <asp:HiddenField runat="server" ID="Distance" />
                            <asp:HiddenField runat="server" ID="Dur" />
                            <asp:Button runat="server" ID="Publish" Text="Publish this offer" CssClass="btn btn-primary" UseSubmitBehavior="false" OnClick="Publish_Click" />
                            <asp:Button runat="server" ID="Save" Text="Save" CssClass="btn btn-primary" UseSubmitBehavior="false" OnClick="Save_Click" />
                        </div>
                    </div>
                </div>
            </section>
        </div>

        <div class="col-md-5">
            <section id="mapView">
                <div class="form-horizontal">
                    <%--<h4>&nbsp;</h4>--%>
                    <hr />
                    <div class="form-group" style="margin-left: 0px; padding-left: 0px">
                        <div id="routeRadius" style="padding: 10px;">
                            <ul style="margin: 0; padding: 0px 10px 0px 10px; list-style: none; background-color: rgba(44,62,80,0.1); border-radius: 3px;">
                                <li style="display: inline-block;">
                                    <i class="fa fa-circle-o fa-2x" aria-hidden="true" style="margin: 5px 0px 5px 0px; vertical-align: middle;"></i>
                                    <i style="vertical-align: middle;">&nbsp;</i>
                                    <i id="radius" style="vertical-align: middle; font-style: normal; font-size: small;">--</i>
                                </li>
                            </ul>
                        </div>

                        <div id="routeDetails" style="padding: 10px;">
                            <ul style="margin: 0; padding: 0px 10px 0px 10px; list-style: none; background-color: rgba(44,62,80,0.1); border-radius: 3px;">
                                <li style="display: inline-block;">
                                    <i class="fa fa-arrows-h fa-2x" aria-hidden="true" style="margin: 5px 0px 5px 0px; vertical-align: middle;"></i>
                                    <i style="vertical-align: middle;">&nbsp;</i>
                                    <i id="distance" style="vertical-align: middle; font-style: normal; font-size: small;">--</i>
                                </li>
                                <li style="display: inline-block;">
                                    <label>&nbsp;&nbsp;&nbsp;</label>
                                </li>
                                <li style="display: inline-block;">
                                    <!--<span class="glyphicon glyphicon-time"></span>-->
                                    <i class="fa fa-clock-o fa-2x" aria-hidden="true" style="margin: 5px 0px 5px 0px; vertical-align: middle;"></i>
                                    <i style="vertical-align: middle;">&nbsp;</i>
                                    <i id="duration" style="vertical-align: middle; font-style: normal; font-size: small;">--</i>
                                </li>
                            </ul>
                        </div>

                        <asp:HyperLink runat="server" ID="editRoute" Style="padding: 4px; font-size: small">| &nbsp;Edit this route</asp:HyperLink>

                        <div id="googleMap" class="jumbotron" style="height: 300px; margin-top: 0px;"></div>

                    </div>
                </div>
            </section>
        </div>

    </div>


    <div id="multipleInfo" class="modal fade in" style="display: block; padding-right: 17px; padding-top: 10%; background-color: rgba(0, 0, 0, 0.4);" tabindex="-1">
        <script type="text/javascript">$("#multipleInfo").hide();</script>
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close clsmodal" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Info</h4>
                </div>
                <div class="modal-body" id="modalBody">
                    By checking this option you will be able to schedule multiple journeys on different dates with the same route.<br />Click on the clanedar to toggle multiple dates.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger btn-sm clsmodal" data-dismiss="modal" style="margin-right:5px;">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
