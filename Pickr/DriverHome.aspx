<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DriverHome.aspx.cs" Inherits="Pickr.DriverHome" %>

<%@ Import Namespace="Pickr.Classes" %>

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



        .range-slider {
            display: inline-block;
            margin: 0px auto;
            padding: 5px;
        }


        .range-slider__range {
            display: inline-block;
            -webkit-appearance: none;
            width: 50%;
            height: 7px;
            border-radius: 5px;
            background: #d4d4d4;
            outline: none;
            padding: 0;
            margin: 0;
        }

            .range-slider__range::-webkit-slider-thumb {
                -webkit-appearance: none;
                appearance: none;
                width: 12px;
                height: 12px;
                border-radius: 50%;
                background: #2c3e50;
                cursor: pointer;
                -webkit-transition: background .15s ease-in-out;
                transition: background .15s ease-in-out;
            }

                .range-slider__range::-webkit-slider-thumb:hover {
                    background: #1abc9c;
                }

            .range-slider__range:active::-webkit-slider-thumb {
                background: #1abc9c;
            }

            .range-slider__range::-moz-range-thumb {
                width: 12px;
                height: 12px;
                border: 0;
                border-radius: 50%;
                background: #2c3e50;
                cursor: pointer;
                -webkit-transition: background .15s ease-in-out;
                transition: background .15s ease-in-out;
            }

                .range-slider__range::-moz-range-thumb:hover {
                    background: #1abc9c;
                }

            .range-slider__range:active::-moz-range-thumb {
                background: #1abc9c;
            }

        .range-slider__value {
            display: inline-block;
            position: relative;
            width: 50px;
            color: #fff;
            line-height: 13px;
            text-align: center;
            border-radius: 3px;
            background: #2c3e50;
            padding: 5px 5px;
            margin-left: 8px;
            font-size: small;
        }

            .range-slider__value:after {
                position: absolute;
                top: 5px;
                left: -5px;
                width: 0;
                height: 0;
                border-top: 6px solid transparent;
                border-right: 6px solid #2c3e50;
                border-bottom: 6px solid transparent;
                content: '';
            }

        ::-moz-range-track {
            background: #d7dcdf;
            border: 0;
        }

        input::-moz-focus-inner,
        input::-moz-focus-outer {
            border: 0;
        }

        

    </style>

    <%--<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/jquery-ui.min.js"></script>--%>

    <%--<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>--%>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBlkwFwPg7dV6fpe_IzEtiPYdnao45B4nY&language=en&libraries=drawing,places,geometry"></script>
    <script src="https://cdn.rawgit.com/bjornharrtell/jsts/gh-pages/1.0.2/jsts.min.js"></script>



    <script type="text/javascript">

        var directionsDisplay;
        var directionsService = new google.maps.DirectionsService();

        var waypoints = [];
        var routeNodes = [];
        var start;
        var end;

        var markersCount = 0;
        var startMarker;
        var destinationMarker;
        var waypointMarker;
        var waypointMarkers = [];

        var range;
        var distance = 100; //radius, not the route distance
        var duration;

        function initialize() {

            //Disable the save button unless a route is set
            document.getElementById('<%= SaveRoute.ClientID %>').disabled = true;

            var lodz = new google.maps.LatLng(51.7592, 19.4560);

            var mapOptions = {
                zoom: 12,
                minZoom: 11,
                center: lodz,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                mapTypeControl: false,
                streetViewControl: false//,
                //styles: [
                //{
                //    featureType: 'all',
                //    stylers: [
                //      { hue: '#ffffff' },
                //      { saturation: -50 }
                //    ]
                //}]
            };

            var map = new google.maps.Map(document.getElementById('googleMap'), mapOptions);
            
            //map.attr('style', '');

            //MARKERS AND DIRECTIONS---------------------------------------------------------------------------------------------------------------------
            directionsDisplay = new google.maps.DirectionsRenderer({
                draggable: true,
                map: map
            });

            directionsDisplay.setMap(map);
            directionsDisplay.setOptions({ suppressMarkers: true }); // To remove the direction default pins A and B
            //Text directions panel
            //directionsDisplay.setPanel(document.getElementById("directionsPanel")); 


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

                else if (markersCount >= 2 && markersCount<10) {
                    waypoints.push({
                        location: e.latLng,
                        stopover: true
                    });
                    placeMarker(e.latLng, map, markersCount + 1);

                    calcRoute(start, waypoints, end);
                    markersCount++;
                }

            });


            // Adding Markers By Search------------------------------------------------

            // Search Start
            var searchStart = (document.getElementById('searchStart'));
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
            var searchDest = (document.getElementById('searchDest'));

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


            // Adding Markers from stored values------------------------------------------------
            <%if (HttpContext.Current.Session["RangeIndices"] != null && HttpContext.Current.Session["Waypoints"] != null && HttpContext.Current.Session["StartCoords"] != null && HttpContext.Current.Session["DestCoords"] != null && HttpContext.Current.Session["Radius"] != null && HttpContext.Current.Session["Duration"] != null)
        { %>

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

            calcRoute(start, waypoints, end);

            <%}%>
            //-----------------------------------------------------------------------------


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


                    // If other markers are added

                else {

                    waypointMarker = new google.maps.Marker({
                        position: position,
                        map: map,
                        draggable: true,
                        title: 'Waypoint',
                        icon: '/Images/waypoint_pin.png',
                        cursor: 'crosshair'
                    });

                    waypointMarkers.push(waypointMarker);

                    var temp;

                    // Marker drag listener
                    google.maps.event.addListener(waypointMarker, 'dragstart', function (e) {
                        temp = e.latLng;
                    });

                    // Marker drag listener
                    google.maps.event.addListener(waypointMarker, 'dragend', function (e) {
                        for (var i = 0; i < waypoints.length; i++) {
                            if (waypoints[i].location == temp)
                                waypoints[i].location = e.latLng;
                        }

                        temp = null;

                        calcRoute(startMarker.getPosition(), waypoints, destinationMarker.getPosition());
                    });


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
                        routeNodes = [];

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
                        document.getElementById('distance').innerHTML = (totalDist / 1000).toPrecision(2) + " km";
                        document.getElementById('duration').innerHTML = duration + " mins";

                        document.getElementById('<%= SaveRoute.ClientID %>').disabled = false;

                    }

                    else {
                        alert("Directions Request from " + startMarker.getPosition().toUrlValue(6) + " to " + destinationMarker.getPosition().toUrlValue(6) + " failed: " + status);
                    }
                });

            }//calcRoute end

            //MARKERS AND DIRECTIONS END


            //POLYGON DRAWING PANEL----------------------------------------------------------------------------------------------------------------------
            //var polygon;
            //var drawingManager = new google.maps.drawing.DrawingManager({
            //    drawingMode: null,
            //    drawingControl: true,
            //    drawingControlOptions: {
            //        position: google.maps.ControlPosition.TOP_CENTER,
            //        drawingModes: [google.maps.drawing.OverlayType.POLYGON]
            //    },
            //    polygonOptions: {
            //        fillOpacity: 0.2,
            //        editable: true,
            //        draggable: true,
            //        fillColor: '#729e47',
            //        strokeColor: '#729e47',
            //        strokeWeight: 2
            //    }
            //});
            //drawingManager.setMap(map);
            // Exit the drawing mode after finishig the polygon
            //google.maps.event.addListener(drawingManager, "overlaycomplete", function (e) {
            //    polygon = e;
            //    drawingManager.setOptions({
            //        drawingMode: null,
            //        drawingControl: false
            //    });
            //});
            //function CustomControl(controlDiv, map) {
            //    // Set CSS for the control border.
            //    var controlUI = document.createElement('div');
            //    controlUI.style.backgroundColor = '#fff';
            //    controlUI.style.border = '2px solid #fff';
            //    controlUI.style.borderRadius = '3px';
            //    controlUI.style.boxShadow = '0 2px 6px rgba(0,0,0,.3)';
            //    controlUI.style.cursor = 'pointer';
            //    controlUI.style.marginBottom = '22px';
            //    controlUI.style.margin = '5px';
            //    controlUI.style.textAlign = 'center';
            //    controlUI.title = 'Click to show poygon coordinates';
            //    controlDiv.appendChild(controlUI);
            //    // Set CSS for the control interior.
            //    var controlText = document.createElement('div');
            //    controlText.style.color = 'rgb(25,25,25)';
            //    controlText.style.fontFamily = 'Roboto,Arial,sans-serif';
            //    controlText.style.fontSize = '12px';
            //    controlText.style.paddingLeft = '5px';
            //    controlText.style.paddingRight = '5px';
            //    controlText.innerHTML = 'Save Route';
            //    controlUI.appendChild(controlText);
            //    // Setup the click event listeners
            //    controlUI.addEventListener('click', function () {
            //        alert(range.getPath().getArray());
            //        console.log(JSON.stringify(range.getPath().getArray()));
            //    });
            //}
            //var customControlDiv = document.createElement('div');
            //var customControl = new CustomControl(customControlDiv, map);
            //customControlDiv.index = 1;
            //map.controls[google.maps.ControlPosition.TOP_LEFT].push(customControlDiv);
            //POLYGON DRAWING PANEL END


            var slider = document.getElementById('sliderContainer');
            var details = document.getElementById('routeDetails');
            map.controls[google.maps.ControlPosition.TOP_LEFT].push(slider);
            map.controls[google.maps.ControlPosition.TOP_RIGHT].push(details);

            //Passing the route date to the C# code behind
            var save = document.getElementById('<%=SaveRoute.ClientID%>');
            save.addEventListener('click', function () {
                //alert(range.getPath().getArray());
                //console.log(JSON.stringify(range.getPath().getArray()));
                var wypts = [];
                for (var i = 0; i < waypoints.length; i++) {
                    wypts[i] = waypoints[i].location;
                }

                var rtpts = [];
                for (var i = 0; i < routeNodes.length; i++) {
                    rtpts[i] = routeNodes[i];
                    console.log(routeNodes[i]);
                }


                //alert(" start: " + startMarker.getPosition() + "\ndest: " + destinationMarker.getPosition() + "\nwaypoints: " + wypts + "\nradius: " + distance.toString());

                document.getElementById('<%=StartCoordinates.ClientID%>').value = JSON.stringify(startMarker.getPosition());
                document.getElementById('<%=DestinationCoordinates.ClientID%>').value = JSON.stringify(destinationMarker.getPosition());
                document.getElementById('<%=WaypointsCoordinates.ClientID%>').value = JSON.stringify(wypts);
                document.getElementById('<%=RoutePointsCoordinates.ClientID%>').value = JSON.stringify(rtpts);
                document.getElementById('<%=RangeIndices.ClientID%>').value = JSON.stringify(range.getPath().getArray());
                document.getElementById('<%=Radius.ClientID%>').value = distance;
                document.getElementById('<%=Duration.ClientID%>').value = duration;

            });


            //Setting the range slider
            var slider = document.getElementById("rangeSlider");
            var value = document.getElementById('<%=rangeValue.ClientID%>');
            
            <%--<%if (HttpContext.Current.Session["Duration"] != null && ((int)HttpContext.Current.Session["Duration"]) == 1000)
            {%>
                value.innerHTML = "1 km";
            <%}
            else if (HttpContext.Current.Session["Duration"] != null) {%>
                value.innerHTML =  <%=(int)HttpContext.Current.Session["Duration"] + " m"%> ;
            <%}%>--%>

            slider.addEventListener("input", function () {
                if (slider.value == 1000)
                    value.innerHTML = "1 km";
                else value.innerHTML = slider.value + " m";
            }, false);

            slider.addEventListener("change", function () {
                distance = slider.value;
                if (range != null)
                    range.setMap(null);

                if (markersCount > 1) {
                    calcRoute(start, waypoints, end);
                }

            }, false);



            //Clear map button
            var clear = document.getElementById("clear");

            clear.addEventListener('click', function () {
                
                value.innerHTML = "100 m";
                slider.value = 100;
                distance = 100;
                duration = 0;

                document.getElementById('distance').innerHTML = "--";
                document.getElementById('duration').innerHTML = "--";
                document.getElementById('<%= SaveRoute.ClientID %>').disabled = true;

                startMarker.setMap(null);
                destinationMarker.setMap(null);

                for (var i = 0; i < waypointMarkers.length; i++) {
                    waypointMarkers[i].setMap(null);
                }

                waypointMarkers.length = 0;
                waypoints.length = 0;
                markersCount = 0;

                directionsDisplay.setMap(null);
                range.setMap(null);

                <%                
                    HttpContext.Current.Session["Waypoints"] = null;
                    HttpContext.Current.Session["RoutePoints"] = null;
                    HttpContext.Current.Session["RangeIndices"] = null;
                    HttpContext.Current.Session["StartCoords"] = null;
                    HttpContext.Current.Session["DestCoords"] = null;
                    HttpContext.Current.Session["Radius"] = null;
                    HttpContext.Current.Session["Duration"] = null;
                %>

            });

        }//intialiaze end


        google.maps.event.addDomListener(window, 'load', initialize);
        
        //jQuery



    </script>
    
    <h2>Plan your next journey</h2>

    <div class="container" style="padding-left:0px; padding-top:20px;">
        <div class="navbar-collapse collapse" style="padding: 0px">
            <ul class="nav navbar-nav">
                <li>
                    <button type="button" id="clear" class="btn btn-primary" style="border-bottom-right-radius:0px; border-top-right-radius:0px;">Clear</button>
                </li>
                <li>
                    <input type="text" id="searchStart" class="form-control" style="border-radius:0px; margin:0px;" placeholder="Start point"/>

                </li>
                <li>
                    <input type="text" id="searchDest" class="form-control" style="border-radius:0px; margin:0px;" placeholder="Destination"/>
                </li>
                <li>
                    <asp:HiddenField runat="server" ID="StartCoordinates" />
                    <asp:HiddenField runat="server" ID="DestinationCoordinates" />
                    <asp:HiddenField runat="server" ID="WaypointsCoordinates" />
                    <asp:HiddenField runat="server" ID="RoutePointsCoordinates" />
                    <asp:HiddenField runat="server" ID="RangeIndices" />
                    <asp:HiddenField runat="server" ID="Radius" />
                    <asp:HiddenField runat="server" ID="Duration" />
                    <asp:Button runat="server" ID="SaveRoute" Text="Save route" CssClass="btn btn-primary" style="border-bottom-left-radius:0px; border-top-left-radius:0px;" OnClick="SaveRoute_Click" />
                </li>
                
            </ul>
        </div>
    </div>

    <div id="sliderContainer" title="Set the radius of your route" style="padding: 10px">
        <ul style="margin: 0; padding: 0; list-style: none; text-align: center;">
            <li style="display: inline-block;">
                <input id="rangeSlider" class="range-slider__range" type="range" value="100" min="0" max="1000" step="100">
            </li>
            <li style="display: inline-block;">
                <span>
                    <asp:Label runat="server" ID="rangeValue" CssClass="range-slider__value">100 m</asp:Label></span>
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

    <div id="googleMap" class="jumbotron"></div>

    <asp:Label ID="test" runat="server"></asp:Label>


    

</asp:Content>
