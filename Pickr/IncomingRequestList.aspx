<%@ Page Title="Incmoing requests" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="IncomingRequestList.aspx.cs" Inherits="Pickr.IncomingRequestList" %>

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
        .time {
            border: none;
            height: 20px;
            width: 25px;
            text-align: center;
            cursor: pointer;
            opacity: 0.5;
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
        var altDirectionsDisplay;
        var directionsService = new google.maps.DirectionsService();

        var waypoints = [];
        var newWaypoints = [];
        var start;
        var end;
        var pick;
        var drop;
        var departure;

        var markersCount = 0;
        var startMarker;
        var destinationMarker;
        var pickMarker;
        var dropMarker;
        var waypointMarker;

        var duration;

        var results = [];

        <%for (var i = 0; i < ((List<Request>)HttpContext.Current.Session["Requests"]).Count; i++)
        {%>

        var str = [];
        var dst = [];
        var dep = [];
        var wpts = [];
        var pck = [];
        var drp = [];
        var id;         

        id = <%=((List<Request>)HttpContext.Current.Session["Requests"])[i].RequestId%>;
        str.push('<%=((List<Request>)HttpContext.Current.Session["Requests"])[i].Offer.Start.lat%>');
        str.push('<%=((List<Request>)HttpContext.Current.Session["Requests"])[i].Offer.Start.lng%>');
        dst.push('<%=((List<Request>)HttpContext.Current.Session["Requests"])[i].Offer.Destination.lat%>');
        dst.push('<%=((List<Request>)HttpContext.Current.Session["Requests"])[i].Offer.Destination.lng%>');
        pck.push('<%=((List<Request>)HttpContext.Current.Session["Requests"])[i].Start.lat%>');
        pck.push('<%=((List<Request>)HttpContext.Current.Session["Requests"])[i].Start.lng%>');
        drp.push('<%=((List<Request>)HttpContext.Current.Session["Requests"])[i].Destination.lat%>');
        drp.push('<%=((List<Request>)HttpContext.Current.Session["Requests"])[i].Destination.lng%>');

        dep.push('<%=((List<Request>)HttpContext.Current.Session["Requests"])[i].Offer.Departure.ToString("HH:mm")%>');

        <%for (var j = 0; j < ((List<Request>)HttpContext.Current.Session["Requests"])[i].Offer.Waypoints.Count; j++)
        {%>

        var wpt = [];
        wpt.push('<%=((List<Request>)HttpContext.Current.Session["Requests"])[i].Offer.Waypoints[j].lat%>');
        wpt.push('<%=((List<Request>)HttpContext.Current.Session["Requests"])[i].Offer.Waypoints[j].lng%>');
        wpts.push(wpt);

        <%}%>

        var ofr = [];
        ofr.push(str);
        ofr.push(dst);
        ofr.push(wpts);
        ofr.push(pck);
        ofr.push(drp);
        ofr.push(id);
        ofr.push(dep);

        results.push(ofr);

        <%}%>

        console.log(JSON.stringify(results));
        //console.log(results);

        function initialize(reqId) {


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
                map: map,
            });


            altDirectionsDisplay = new google.maps.DirectionsRenderer({
                draggable: false,
                map: map,
                polylineOptions: {
                    strokeColor: "#F39C12",
                    strokeOpacity: 0.8,
                    strokeWeight: 5
                }
            });


            
            directionsDisplay.setMap(map);
            directionsDisplay.setOptions({ suppressMarkers: true }); // To remove the direction default pins A and B
            directionsDisplay.setPanel(document.getElementById("directionsPanel")); //??????????????

            altDirectionsDisplay.setMap(map);
            altDirectionsDisplay.setOptions({ suppressMarkers: true }); // To remove the direction default pins A and B
            altDirectionsDisplay.setPanel(document.getElementById("directionsPanel")); //??????????????

            
            var wypts = [];

            for (var i=0; i< results.length; i++)
            {
                if(results[i][5] == reqId) {

                    var lat = results[i][0][0];
                    var lng = results[i][0][1];
                    start = new google.maps.LatLng(lat, lng);

                    lat = results[i][1][0];
                    lng = results[i][1][1];
                    end = new google.maps.LatLng(lat, lng);

                    departure = results[i][6];

                    lat = results[i][3][0];
                    lng = results[i][3][1];
                    pick = new google.maps.LatLng(lat, lng);

                    lat = results[i][4][0];
                    lng = results[i][4][1];
                    drop = new google.maps.LatLng(lat, lng);


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


            for (var i = 0; i < wypts.length; i++) {
                newWaypoints.push({
                    location: wypts[i],
                    stopover: true
                });
            }


            newWaypoints.push({
                location: pick,
                stopover: true
            });

            newWaypoints.push({
                location: drop,
                stopover: true
            });

            console.log("New waypoints: "+JSON.stringify(newWaypoints));


            placeMarker(start, map, 1);
            markersCount++;
            placeMarker(end, map, 2);
            markersCount++;

            placeMarker(pick, map, 3);
            markersCount++;
            placeMarker(drop, map, 4);
            markersCount++;


            if (wypts.length > 0) {
                for (var i = 0; i < wypts.length; i++) {
                    placeMarker(waypoints[i].location, map, markersCount+1);
                    markersCount++;
                }
            }

            
            
            calcAlternateRoute(start, newWaypoints, end);
            calcRoute(start, waypoints, end);

            // Place a marker on the map
            function placeMarker(position, map, index) {

                var infowindow;
                var geocoder;

                //Show coordinates of any place marker in console
                //console.log("index: "+index+" - lat: " + position.lat() + " lng: " + position.lng());

                // If the first marker is added
                if (index == 1) {

                    startMarker = new google.maps.Marker({
                        position: position,
                        map: map,
                        draggable: false,
                        title: 'Start',
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


                    // If the pickup marker is added
                else if (index == 3) {
                    pickMarker = new google.maps.Marker({
                        position: position,
                        map: map,
                        draggable: false,
                        title: 'Pick up',
                        animation: google.maps.Animation.BOUNCE,
                        icon: '/Images/waypoint_pin.png',
                        cursor: 'crosshair'
                    });


                    // Marker click listener: Open infowindow showing place info
                    infowindow = new google.maps.InfoWindow();
                    geocoder = new google.maps.Geocoder;

                    google.maps.event.addListener(pickMarker, 'click', function () {

                        var placeID;

                        //Places Library to retrieve the place name
                        var service = new google.maps.places.PlacesService(map);

                        // Geocode library to retrieve the place address
                        geocoder.geocode({ 'location': pickMarker.getPosition() }, function (results, status) {
                            if (status === google.maps.GeocoderStatus.OK) {
                                if (results[0]) {

                                    placeID = results[0].place_id;

                                    service.getDetails({
                                        placeId: placeID
                                    }, function (place, status) {
                                        infowindow.setContent('<div><strong>' + place.name + '</strong></br>' + place.formatted_address);
                                        pickMarker.infowindow = infowindow;
                                        infowindow.open(map, pickMarker);
                                    });

                                }
                            }
                        });
                    });
                }


                    // If the dropoff marker is added
                else if (index == 4) {
                    dropMarker = new google.maps.Marker({
                        position: position,
                        map: map,
                        draggable: false,
                        title: 'Drop off',
                        animation: google.maps.Animation.BOUNCE,
                        icon: '/Images/waypoint_pin.png',
                        cursor: 'crosshair'
                    });


                    // Marker click listener: Open infowindow showing place info
                    infowindow = new google.maps.InfoWindow();
                    geocoder = new google.maps.Geocoder;

                    google.maps.event.addListener(dropMarker, 'click', function () {

                        var placeID;

                        //Places Library to retrieve the place name
                        var service = new google.maps.places.PlacesService(map);

                        // Geocode library to retrieve the place address
                        geocoder.geocode({ 'location': dropMarker.getPosition() }, function (results, status) {
                            if (status === google.maps.GeocoderStatus.OK) {
                                if (results[0]) {

                                    placeID = results[0].place_id;

                                    service.getDetails({
                                        placeId: placeID
                                    }, function (place, status) {
                                        infowindow.setContent('<div><strong>' + place.name + '</strong></br>' + place.formatted_address);
                                        dropMarker.infowindow = infowindow;
                                        infowindow.open(map, dropMarker);
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

                        //console.log("route nodes:\n" + JSON.stringify(routeNodes));
                        //console.log("number of nodes:\n" + routeNodes.length);



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
            
            function calcAlternateRoute(start, newWaypoints, end) {

                var request = {
                    origin: startMarker.getPosition(),
                    destination: destinationMarker.getPosition(),
                    waypoints: newWaypoints,
                    optimizeWaypoints: true,
                    travelMode: google.maps.TravelMode.DRIVING
                };

                altDirectionsService = new google.maps.DirectionsService();
                altDirectionsService.route(request, function (response, status) {
                    if (status == google.maps.DirectionsStatus.OK) {
                        altDirectionsDisplay.setDirections(response);
                        altDirectionsDisplay.setMap(map);

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
                                }
                            }
                        }


                        var closest = findClosestPointIndex(pick, routeNodes);


                        // Calculating the route distance and duration
                        var totalDist = 0;
                        var totalTime = 0;
                        var timeToPickup = 0;
                        var durations = [];

                        legs = myroute.legs;
                        for (i = 0; i < legs.length; i++) {
                            totalDist += legs[i].distance.value;
                            totalTime += legs[i].duration.value;
                            
                            var steps = legs[i].steps;
                            for (j = 0; j < steps.length; j++) {
                                var path = steps[j].path;
                                for (k = 0; k < path.length; k++) {
                                    if((Number(path[k].lat()) == Number(closest.lat())) && (Number(path[k].lng()) == Number(closest.lng()))) {
                                        //placeMarker(path[k],map, 2);
                                        //console.log("i: "+i+" - j: "+j+" - k: "+k);
                                        durations.push(totalTime);
                                        //console.log(Math.floor(timeToPickup / 60) +" mins");
                                        
                                    }
                                }
                            }
                        }


                        function arrayMin(arr) {
                            return arr.reduce(function (p, v) {
                                return ( p < v ? p : v );
                            });
                        }

                        //var time = departure.split(":");
                        var mins = Math.floor(arrayMin(durations) / 60);
                        //var total = Number(time[1])+Number(mins);
                        //if(total>60) {
                        //    time[0] = Number(time[0]) + Number(total / 60);
                        //}

                        var time = String(departure).split(":");
                        var mydate = new Date();

                        mydate.setHours(Number(time[0]));
                        mydate.setMinutes(Number(time[1]));
                        mydate.setMinutes(mydate.getMinutes() + mins);

                        document.getElementById('distanceDuration').innerHTML = "Estimated time to pick-up point: <strong>" + mins + " mins (at "+mydate.getHours()+":"+mydate.getMinutes()+")</strong>";
                        var h  = document.getElementById('hour');
                        var m = document.getElementById('minute');
                        h.value = mydate.getHours() < 10 ? "0"+ mydate.getHours() : mydate.getHours() + "";
                        m.value = mydate.getMinutes() < 10 ? "0" + mydate.getMinutes() : mydate.getMinutes() + "";

                        h.addEventListener('focus', function () {
                            document.querySelector("#hour").style.opacity = "1";
                            document.getElementById('<%=Approve.ClientID%>').disabled = true;
                        });

                        m.addEventListener('focus', function () {
                            document.querySelector("#minute").style.opacity = "1";
                            document.getElementById('<%=Approve.ClientID%>').disabled = true;
                        });

                        
                        var save = document.getElementById('save');
                        save.addEventListener('click', function () {

                            document.getElementById('<%=SelectedRequest.ClientID%>').value = reqId;
                            document.getElementById('<%=PickUpHour.ClientID%>').value = document.getElementById('hour').value;
                            document.getElementById('<%=PickUpMinute.ClientID%>').value = document.getElementById('minute').value;

                            document.getElementById('<%=Approve.ClientID%>').disabled = false;
                        });

                        


                        duration = Math.floor(totalTime / 60);
                        var dist = (totalDist / 1000).toPrecision(2);
                        document.getElementById('distanceNew').innerHTML = dist + " km";
                        document.getElementById('durationNew').innerHTML = duration + " mins";
                    }

                    else {
                        alert("Directions Request from " + startMarker.getPosition().toUrlValue(6) + " to " + destinationMarker.getPosition().toUrlValue(6) + " failed: " + status);
                    }
                });


                var d;
                function findClosestPointIndex(point, points) {
                
                    function distance(p) {
                        return 100000 * Math.sqrt( Math.pow((point.lat()-p.lat()), 2) + Math.pow((point.lng()-p.lng()), 2) );
                    }
                
                    var tempDist = 0;
                    var closest = points[0];
                    d = distance(points[0]);

                    for (i = 1; i < points.length; i++)
                    {
                        tempDist = distance(points[i]);

                        if (Number(tempDist) < d)
                        {
                            d = distance(points[i]);
                            closest = points[i];
                        }
                    }

                    return closest;
                }

            }//calcRoute end



            

        }//intialiaze end


        function decreaseOpacity() {
            document.querySelector("#hour").style.opacity = "0.5";
            document.querySelector("#minute").style.opacity = "0.5";
        }

        


        //Dialog boxes---------------------------------------------------------------
        var reqId;

        $(document).ready(function () {

            //$("#requestInfo").hide();

            $(".approve").click(function (e) {
                e.preventDefault();
                $("#pickUpInfo").fadeIn(300, function () { $(this).focus(); });
                reqId = $(this).closest('tr').find('td:eq(0)').text();
                initialize(reqId);
                waypoints = [];
                newWaypoints = [];
                markersCount = 0;
            });

            $('.clsmodal').click(function () {
                $("#pickUpInfo").fadeOut(300);
                $("#mapInfo").fadeOut(300);
                decreaseOpacity();
            });

            $(".info").click(function (e) {
                e.preventDefault();
                $("#mapInfo").fadeIn(300, function () { $(this).focus(); });
                reqId = $(this).closest('tr').find('td:eq(0)').text();
                initialize(reqId);
                waypoints = [];
                newWaypoints = [];
                markersCount = 0;
            });


        });

    </script>



    <h2 runat="server" id="Header">Incoming Reqeusts</h2>
    <p class="text-danger">
        <asp:Literal runat="server" ID="ErrorMessage" />
    </p>

    <p id="test" class="test"></p>

    <asp:Table runat="server" ID="pendingRequestList" CssClass="table table-striped table-hover "></asp:Table>
    <asp:HiddenField runat="server" ID="SelectedOffer" />

    <div id="mapInfo" class="modal fade in" style="display: block; padding-right: 17px; background-color: rgba(0, 0, 0, 0.4);" tabindex="-1">
        <script type="text/javascript">$("#mapInfo").hide();</script>
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close clsmodal" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Route Suggestion</h4>
                </div>
                <div class="modal-body">
                    <div id="wrapper" style="position: relative;">
                        <div id="googleMap" class="jumbotron" style="height: 300px; margin-top: 0px; margin-bottom: 0px;"></div>

                        <div id="routeDetails" style="position: absolute; top: 10px; right: 10px; z-index: 99; background-color: rgba(44,62,80,0.1); border-radius: 3px;">
                            <ul style="margin: 0; padding: 0px 10px 0px 10px; list-style: none; background-color: #3498DB; color: white; border-top-left-radius: 3px; border-top-right-radius: 3px;">
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
                            <!--<hr />-->
                            <ul style="margin: 0; padding: 0px 10px 0px 10px; list-style: none; background-color: #F39C12; color: white; border-bottom-left-radius: 3px; border-bottom-right-radius: 3px;">
                                <li style="display: inline-block;">
                                    <i class="fa fa-arrows-h fa-2x" aria-hidden="true" style="margin: 5px 0px 5px 0px; vertical-align: middle; font-size: large; opacity: 0;"></i>
                                    <i style="vertical-align: middle;">&nbsp;</i>
                                    <i id="distanceNew" style="vertical-align: middle; font-style: normal; font-size: small;">--</i>
                                </li>
                                <li style="display: inline-block;">
                                    <label>&nbsp;&nbsp;&nbsp;</label>
                                </li>
                                <li style="display: inline-block;">
                                    <!--<span class="glyphicon glyphicon-time"></span>-->
                                    <i class="fa fa-clock-o fa-2x" aria-hidden="true" style="margin: 5px 0px 5px 0px; vertical-align: middle; font-size: large; opacity: 0;"></i>
                                    <i style="vertical-align: middle;">&nbsp;</i>
                                    <i id="durationNew" style="vertical-align: middle; font-style: normal; font-size: small;">--</i>
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


    <div id="pickUpInfo" class="modal fade in" style="display: block; padding-right: 17px; padding-top: 10%; background-color: rgba(0, 0, 0, 0.4);" tabindex="-1">
        <script type="text/javascript">$("#pickUpInfo").hide();</script>
        <div class="modal-dialog modal-md" style="width:450px;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close clsmodal" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Pick-up Time</h4>
                </div>
                <div class="modal-body" id="modalBody">
                    <p id="distanceDuration"></p>
                    <p>Choose a suitable pick-up time</p>
                    <div class="input-group">
                        <span class="input-group-addon input-sm"><i class="fa fa-clock-o fa-2x" aria-hidden="true" style="margin: 0px 0px 0px 0px; vertical-align: middle; font-size: large;"></i></span>
                        <input type="text" class="form-control input-sm" style="width: 40%" onfocus="getElementById('hour').select();" />
                        <div style="position: absolute; left: 50px; top: 5px; z-index: 99; margin: auto;">
                            <input type="number" min="0" max="23" value="09" class="time" id="hour" onclick="this.select(); var sheet = document.createElement('style'); sheet.innerHTML = '#hour {color=black;}'; this.appendChild(sheet);" onchange="if(parseInt(this.value,10)<10)this.value='0'+this.value; if(parseInt(this.value,10)>23)this.value=23; if(parseInt(this.value,10)<0)this.value='01';" />
                            <label>:</label>
                            <input type="number" min="0" max="59" value="09" class="time" id="minute" onclick="this.select(); " onchange="if(parseInt(this.value,10)<10)this.value='0'+this.value; if(parseInt(this.value,10)>59)this.value=59; if(parseInt(this.value,10)<0)this.value='01';" />
                        </div>
                        <span class="input-group-btn">
                            <button type="button" id="save" class="btn btn-primary btn-sm" style="border-radius:2px;"><i class="fa fa-floppy-o fa-2x" aria-hidden="true" style="margin: 0px 0px 0px 0px; vertical-align: middle; font-size: medium;"></i></button>
                        </span>
                    </div>
                    
                    <%--<asp:TextBox runat="server" ID="Pick" CssClass="form-control input-sm" TextMode="DateTimeLocal" onchange="this.value = minmaxTime(this.value)" />--%>
                    <%--<asp:RequiredFieldValidator runat="server" ControlToValidate="Pick" CssClass="text-danger" ErrorMessage="The pick-up time must be specified." Display="Dynamic" /></br>--%>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger btn-sm clsmodal" data-dismiss="modal" style="margin-right:5px;">Cancel</button>
                    <asp:HiddenField runat="server" ID="SelectedRequest" />
                    <asp:HiddenField runat="server" ID="PickUpHour" />
                    <asp:HiddenField runat="server" ID="PickUpMinute" />

                    <asp:Button runat="server" ID="Approve" Text="Approve request" CssClass="btn btn-primary btn-sm send" UseSubmitBehavior="true" OnClick="Approve_Click" Enabled="false"  style="border-bottom-left-radius:0px;border-top-left-radius:0px; margin-left:0px;"/>
                </div>
            </div>
        </div>
    </div>



</asp:Content>
