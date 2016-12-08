<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PassengerHome.aspx.cs" Inherits="Pickr.PassengerHome" %>

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
            font-size: 15px;
            font-weight: 300;
            margin-left: 12px;
            padding: 11px 11px 11px 13px;
            margin-right: 20px;
            text-overflow: ellipsis;
            width: 300px;
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
        var waypoints = [];
        var range;

        function initialize() {

            //Disable the save button unless a route is set
            document.getElementById('<%= SearchRide.ClientID %>').disabled = true;

            var lodz = new google.maps.LatLng(51.7592, 19.4560);

            var mapOptions = {
                zoom: 12,
                minZoom: 11,
                center: lodz,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                mapTypeControl: false
            };

            var map = new google.maps.Map(document.getElementById('googleMap'), mapOptions);

            var polylineOptionsActual = new google.maps.Polyline({
                strokeColor: '#FF0000',
                strokeOpacity: 0
            });

            //MARKERS AND DIRECTIONS---------------------------------------------------------------------------------------------------------------------
            directionsDisplay = new google.maps.DirectionsRenderer({
                draggable: false,
                map: map,
                polylineOptions: polylineOptionsActual
            });

            directionsDisplay.setMap(map);
            directionsDisplay.setOptions({ suppressMarkers: true }); // To remove the direction default pins A and B
            directionsDisplay.setPanel(document.getElementById("directionsPanel")); //??????????????

            var markersCount = 0;
            var start;
            var end;

            var startMarker;
            var destinationMarker;
            var waypointMarker;




            //Adding Markers By Click Event--------------------------------------------

            // This event listener calls placeMarker() when the map is clicked.
            google.maps.event.addListener(map, 'click', function (e) {

                if (markersCount == 0) {
                    start = e.latLng;
                    placeMarker(e.latLng, map, 1);
                    markersCount++;
                }

                else if (markersCount == 1) {

                    end = e.latLng;
                    placeMarker(e.latLng, map, 2);
                    calcRoute(start, waypoints, end);
                    markersCount++;
                }

                else if (markersCount >= 2 /*&& waypoints.length > 9*/) {
                    waypoints.push({
                        location: e.latLng,
                        stopover: true
                    });
                    placeMarker(e.latLng, map, markersCount + 1);

                    calcRoute(start, waypoints, end);
                    markersCount++;
                }

            });


            // Adding Markers By Search--------------------------------------------



            // Search Start
            var searchStart = (document.getElementById('<%=srchStart.ClientID%>'));
            var autocomplete = new google.maps.places.Autocomplete(searchStart);
            autocomplete.setComponentRestrictions({ country: "pl" });
            autocomplete.bindTo('bounds', map);

            //var infowindow = new google.maps.InfoWindow();

            autocomplete.addListener('place_changed', function () {

                //infowindow.close();
                //startMarker.setVisible(false);
                var place = autocomplete.getPlace();
                if (!place.geometry) {
                    window.alert("Autocomplete's returned place contains no geometry");
                    return;
                }


                // If the place has a geometry, then present it on a map.
                if (place.geometry.viewport) {
                    map.fitBounds(place.geometry.viewport);
                } //else {
                //    map.setCenter(place.geometry.location);
                //    map.setZoom(12);
                //}

                // If there is no start marker, create a new one
                if (startMarker == null) {
                    placeMarker(place.geometry.location, map, 1);
                    markersCount++;
                }

                    // If there is a start marker already, change its position and calculate the new route
                else {
                    startMarker.setPosition(place.geometry.location);
                    if (destinationMarker != null) {
                        calcRoute(startMarker.getPosition(), waypoints, destinationMarker.getPosition());
                    }
                }

                //var address = '';
                //if (place.address_components) {
                //    address = [
                //      (place.address_components[0] && place.address_components[0].short_name || ''),
                //      (place.address_components[1] && place.address_components[1].short_name || ''),
                //      (place.address_components[2] && place.address_components[2].short_name || '')
                //    ].join(' ');
                //}

                //infowindow.setContent('<div><strong>' + place.name + '</strong><br>' + address);
                //infowindow.open(map, startMarker);

            });

            // Search Destination
            var searchDest = (document.getElementById('<%=srchDest.ClientID%>'));

            if (markersCount == 0) {
                searchDest.disabled = true;
            }

            var autocomplete2 = new google.maps.places.Autocomplete(searchDest);
            autocomplete2.setComponentRestrictions({ country: "pl" });
            autocomplete2.bindTo('bounds', map);

            //var infowindow = new google.maps.InfoWindow();

            autocomplete2.addListener('place_changed', function () {

                //infowindow.close();
                //startMarker.setVisible(false);
                var place2 = autocomplete2.getPlace();
                if (!place2.geometry) {
                    window.alert("Autocomplete's returned place contains no geometry");
                    return;
                }


                // If the place has a geometry, then present it on a map.
                if (place2.geometry.viewport) {
                    map.fitBounds(place2.geometry.viewport);
                } //else {
                //    map.setCenter(place2.geometry.location);
                //    map.setZoom(12);
                //}


                // If there is no destination marker, create a new one
                if (destinationMarker == null) {
                    placeMarker(place2.geometry.location, map, 2);
                    calcRoute(startMarker.getPosition(), waypoints, destinationMarker.getPosition());
                    markersCount++;


                }

                    // If there is a destination marker already, change its position and calculate the new route
                else {
                    destinationMarker.setPosition(place2.geometry.location);
                    calcRoute(startMarker.getPosition(), waypoints, destinationMarker.getPosition());
                }

            });


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
                        draggable: true,
                        title: 'Start',
                        animation: google.maps.Animation.BOUNCE,
                        icon: '/Images/start_pin.png',
                        cursor: 'crosshair'
                    });

                    //alert(startMarker.getPosition().getPlace());

                    searchDest.disabled = false;
                    document.getElementById('<%=ArrivalFrom.ClientID%>').disabled = false;

                    // Marker drag listener
                    google.maps.event.addListener(startMarker, 'dragend', function () {
                        if (destinationMarker != null) {
                            calcRoute(startMarker.getPosition(), waypoints, destinationMarker.getPosition());
                        }

                        startMarker.infowindow.close();
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
                        draggable: true,
                        title: 'Destination',
                        animation: google.maps.Animation.BOUNCE,
                        icon: '/Images/destination_pin.png',
                        cursor: 'crosshair'
                    });



                    // Marker drag listener
                    google.maps.event.addListener(destinationMarker, 'dragend', function () {
                        calcRoute(startMarker.getPosition(), waypoints, destinationMarker.getPosition());
                        destinationMarker.infowindow.close();
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


                        // Calculating the route distance and duration
                        var totalDist = 0;
                        var totalTime = 0;

                        for (i = 0; i < myroute.legs.length; i++) {
                            totalDist += myroute.legs[i].distance.value;
                            totalTime += myroute.legs[i].duration.value;
                        }

                        duration = Math.floor(totalTime / 60);
                        document.getElementById('distance').innerHTML = "≈ " + (totalDist / 1000).toPrecision(2) + " km";
                        document.getElementById('duration').innerHTML = "≈ " + duration + " mins";

                        //document.getElementById('SearchRide').disabled = false;
                        document.getElementById('<%=ArrivalFrom.ClientID%>').disabled = false;
                        if (String(arrivalFrom.value)) document.getElementById('<%= SearchRide.ClientID %>').disabled = false;

                    }

                    else {
                        alert("Directions Request from " + startMarker.getPosition().toUrlValue(6) + " to " + destinationMarker.getPosition().toUrlValue(6) + " failed: " + status);
                    }
                });

            }//calcRoute end

            //MARKERS AND DIRECTIONS END



            //Manage date pickers events
            var arrivalFrom = document.getElementById('<%=ArrivalFrom.ClientID%>');
            var arrivalTo = document.getElementById('<%=ArrivalTo.ClientID%>');

            arrivalFrom.disabled = true;
            arrivalTo.disabled = true;

            arrivalFrom.addEventListener('click', function () {
                if (String(arrivalFrom.value)) {
                    if (markersCount == 2)
                        document.getElementById('<%= SearchRide.ClientID %>').disabled = false;

                    arrivalTo.disabled = false;
                }

                else {
                    document.getElementById('<%= SearchRide.ClientID %>').disabled = true;
                    arrivalTo.disabled = true;
                }
            });

            arrivalFrom.addEventListener('keyup', function () {
                if (String(arrivalFrom.value)) {
                    if (markersCount == 2)
                        document.getElementById('<%= SearchRide.ClientID %>').disabled = false;

                    arrivalTo.disabled = false;
                }

                else {
                    document.getElementById('<%= SearchRide.ClientID %>').disabled = true;
                    arrivalTo.disabled = true;
                }
            });

            arrivalFrom.addEventListener('keydown', function () {
                if (String(arrivalFrom.value)) {
                    if (markersCount == 2)
                        document.getElementById('<%= SearchRide.ClientID %>').disabled = false;

                    arrivalTo.disabled = false;
                }

                else {
                    document.getElementById('<%= SearchRide.ClientID %>').disabled = true;
                    arrivalTo.disabled = true;
                }
            });



            //Passing the seach query to the C# code behind
            var search = document.getElementById('<%=SearchRide.ClientID%>');
            search.addEventListener('click', function () {
                document.getElementById('<%=StartCoordinates.ClientID%>').value = JSON.stringify(startMarker.getPosition());
                document.getElementById('<%=DestinationCoordinates.ClientID%>').value = JSON.stringify(destinationMarker.getPosition());
                document.getElementById('<%=ArrivalF.ClientID%>').value = String(arrivalFrom.value);
                document.getElementById('<%=ArrivalT.ClientID%>').value = String(arrivalTo.value);
            });


            var details = document.getElementById('routeDetails');
            map.controls[google.maps.ControlPosition.TOP_RIGHT].push(details);

        }//intialiaze end


        google.maps.event.addDomListener(window, 'load', initialize);


    </script>
    <h2>Find your next Pickr</h2>

    <ul class="nav navbar-nav" style="margin: 0; padding: 20px 0px 20px 0px; list-style: none;">
        <li style="display: inline-block;">
            <input runat="server" type="text" id="srchStart" class="form-control" style="border-bottom-right-radius:0px;border-top-right-radius:0px;" placeholder="Start Point"></input>

        </li>
        <li style="display: inline-block;">
            <input runat="server" type="text" id="srchDest" class="form-control" style="border-bottom-left-radius:0px;border-top-left-radius:0px;"  placeholder="Destination"></input>
        </li>
        <li style="display: inline-block; ">
            <input runat="server" type="text" class="form-control" style="cursor:default;margin-left:20px; width:140px;border-bottom-right-radius:0px;border-top-right-radius:0px; border-right-width:0px; font-weight:600; color:#2C3E50; background-color:#ECF0F1;" onfocus="this.blur();" value="Arrive Between"/>
        </li>
        <%--<li style="display: inline-block;">
            <label style="vertical-align: middle; font-style: normal; margin:10px;">Arrive between</label>
        </li>--%>
        <li style="display: inline-block; width:20%;">
            <div style="padding: 0px; " >
                <asp:TextBox runat="server" ID="ArrivalFrom" CssClass="form-control" TextMode="DateTimeLocal" style="border-radius:0px;"/>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="ArrivalFrom" />
            </div>
        </li>
        <li style="display: inline-block; ">
            <input runat="server" type="text" class="form-control" style="cursor:default; width:55px;border-radius:0px; border-right-width:0px; border-left-width:0px; font-weight:600; color:#2C3E50; padding:10px; text-align:center; background-color:#ECF0F1;" onfocus="this.blur();" value="And"/>
        </li>
        <li style="display: inline-block;  width:20%;">
            <div style="padding: 0px;">
                <asp:TextBox runat="server" ID="ArrivalTo" CssClass="form-control" TextMode="DateTimeLocal" style="border-radius:0px;"/>
            </div>
        </li>
        <li style="display: inline-block;">
            <asp:HiddenField runat="server" ID="StartCoordinates" />
            <asp:HiddenField runat="server" ID="DestinationCoordinates" />
            <asp:HiddenField runat="server" ID="ArrivalF" />
            <asp:HiddenField runat="server" ID="ArrivalT" />
            <asp:Button runat="server" ID="SearchRide" Text="Search" CssClass="btn btn-primary" style="border-bottom-left-radius:0px;border-top-left-radius:0px;" OnClick="SearchRide_Click" />
        </li>
    </ul>



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

    <div id="googleMap" class="jumbotron" style="height: 500px; margin-top:100px;"></div>

    <asp:Label ID="test" runat="server"></asp:Label>


</asp:Content>
