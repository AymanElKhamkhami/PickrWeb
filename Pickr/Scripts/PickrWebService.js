/* Pickr JSON Web Service */
function PickrWebService() { self = this; }

function someeAdRemover(response) {
    var rawResponse = JSON.stringify(response);
    var handledResponse = rawResponse.substring(1, rawResponse.indexOf("<"));
    var handledResponse = handledResponse.replace(/\\n/g, "\n")
                    .replace(/\\'/g, "\'")
                    .replace(/\\"/g, '\"')
                    .replace(/\\&/g, "\&")
                    .replace(/\\r/g, "\r")
                    .replace(/\\t/g, "\t")
                    .replace(/\\b/g, "\b")
                    .replace(/\\f/g, "\f")
                    .replace(/[\u0000-\u001F]+/g, "");
                    //.replace(/ /g, "");

    var jsonResponse = JSON.parse(handledResponse);
    return jsonResponse;
}

var somee = false;

PickrWebService.prototype = {
    self: null,
    //urlString: "http://localhost:8080/Handler.ashx",
    urlString: "http://pickrwebservice.somee.com/Handler.ashx",

    CreateUser: function (Email, Username, Password, FirstName, Surname, Birth, Gender, Mobile, Picture, Address, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'CreateUser', 'parameters': { 'Email': Email, 'Username': Username, 'Password': Password, 'FirstName': FirstName, 'Surname': Surname, 'Birth': Birth, 'Gender': Gender, 'Mobile': Mobile, 'Picture': Picture, 'Address': Address }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    CheckUserExistence: function (Email, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'CheckUserExistence', 'parameters': { 'Email': Email }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    UserAuthentication: function (Email, Password, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'UserAuthentication', 'parameters': { 'Email': Email, 'Password': Password }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    GetUser: function (Email, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'GetUser', 'parameters': { 'Email': Email }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    GetUserPublic: function (IdUser, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'GetUserPublic', 'parameters': { 'IdUser': IdUser }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    UpdateUser: function (Email, FirstName, Surname, Birth, Gender, Mobile, Picture, Address, Mode, CarModel, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'UpdateUser', 'parameters': { 'Email': Email, 'FirstName': FirstName, 'Surname': Surname, 'Birth': Birth, 'Gender': Gender, 'Mobile': Mobile, 'Picture': Picture, 'Address': Address, 'Mode': Mode, 'CarModel': CarModel }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    SetUserPreferences: function (Email, Smoking, Music, Pets, Talking, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'SetUserPreferences', 'parameters': { 'Email': Email, 'Smoking': Smoking, 'Music': Music, 'Pets': Pets, 'Talking': Talking }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    CreatePreferences: function (Smoking, Music, Pets, Talking, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'CreatePreferences', 'parameters': { 'Smoking': Smoking, 'Music': Music, 'Pets': Pets, 'Talking': Talking }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    UpdatePreferences: function (idPreferences, Smoking, Music, Pets, Talking, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'UpdatePreferences', 'parameters': { 'idPreferences': idPreferences, 'Smoking': Smoking, 'Music': Music, 'Pets': Pets, 'Talking': Talking }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    CreateOffer: function (Email, StartLat, StartLng, DestinationLat, DestinationLng, Waypoints, RoutePoints, RangePolygon, Departure, Arrival, Seats, Price, Radius, Distance, Active, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'CreateOffer', 'parameters': { 'Email': Email, 'StartLat': StartLat, 'StartLng': StartLng, 'DestinationLat': DestinationLat, 'DestinationLng': DestinationLng, 'Waypoints': Waypoints, 'RoutePoints': RoutePoints, 'RangePolygon': RangePolygon, 'Departure': Departure, 'Arrival': Arrival, 'Seats': Seats, 'Price': Price, 'Radius': Radius, 'Distance': Distance, 'Active': Active }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    GetOffersList: function (Email, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'GetOffersList', 'parameters': { 'Email': Email }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    GetRequestedOffersList: function (OfferIds, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'GetRequestedOffersList', 'parameters': { 'OfferIds': OfferIds }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    UpdateOffer: function (IdOffer, StartLat, StartLng, DestinationLat, DestinationLng, Waypoints, RoutePoints, RangePolygon, Departure, Arrival, Seats, ReservedSeats, Price, Radius, Distance, Active, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'UpdateOffer', 'parameters': { 'IdOffer': IdOffer, 'StartLat': StartLat, 'StartLng': StartLng, 'DestinationLat': DestinationLat, 'DestinationLng': DestinationLng, 'Waypoints': Waypoints, 'RoutePoints': RoutePoints, 'RangePolygon': RangePolygon, 'Departure': Departure, 'Arrival': Arrival, 'Seats': Seats, 'ReservedSeats': ReservedSeats, 'Price': Price, 'Radius': Radius, 'Distance': Distance, 'Active': Active }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    DeleteOffer: function (IdOffer, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'DeleteOffer', 'parameters': { 'IdOffer': IdOffer }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    CreateWaypointsList: function (IdOffer, Waypoints, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'CreateWaypointsList', 'parameters': { 'IdOffer': IdOffer, 'Waypoints': Waypoints }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    CreateRoutePointsList: function (IdOffer, RoutePoints, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'CreateRoutePointsList', 'parameters': { 'IdOffer': IdOffer, 'RoutePoints': RoutePoints }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    CreatePolygon: function (IdOffer, RangePolygon, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'CreatePolygon', 'parameters': { 'IdOffer': IdOffer, 'RangePolygon': RangePolygon }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    GetWaypointsList: function (IdOffer, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'GetWaypointsList', 'parameters': { 'IdOffer': IdOffer }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    GetRoutePointsList: function (IdOffer, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'GetRoutePointsList', 'parameters': { 'IdOffer': IdOffer }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    GetRangeIndices: function (IdOffer, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'GetRangeIndices', 'parameters': { 'IdOffer': IdOffer }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    DeleteWaypointsList: function (IdOffer, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'DeleteWaypointsList', 'parameters': { 'IdOffer': IdOffer }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    DeletePolygon: function (IdOffer, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'DeletePolygon', 'parameters': { 'IdOffer': IdOffer }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    DeleteRoutePointsList: function (IdOffer, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'DeleteRoutePointsList', 'parameters': { 'IdOffer': IdOffer }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    SearchRides: function (ArrivalFrom, ArrivalTo, StartLat, StartLng, DestinationLat, DestinationLng, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'SearchRides', 'parameters': { 'ArrivalFrom': ArrivalFrom, 'ArrivalTo': ArrivalTo, 'StartLat': StartLat, 'StartLng': StartLng, 'DestinationLat': DestinationLat, 'DestinationLng': DestinationLng }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    CreateRequest: function (Email, IdOffer, StartLat, StartLng, DestinationLat, DestinationLng, ArrivalFrom, ArrivalTo, Seats, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'CreateRequest', 'parameters': { 'Email': Email, 'IdOffer': IdOffer, 'StartLat': StartLat, 'StartLng': StartLng, 'DestinationLat': DestinationLat, 'DestinationLng': DestinationLng, 'ArrivalFrom': ArrivalFrom, 'ArrivalTo': ArrivalTo, 'Seats': Seats }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    GetDriverReceivedRequests: function (Email, Approved, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'GetDriverReceivedRequests', 'parameters': { 'Email': Email, 'Approved': Approved }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    GetPassengerSentRequests: function (Email, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'GetPassengerSentRequests', 'parameters': { 'Email': Email }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    RespondToRequest: function (IdRequest, PickUp, Approved, Rejected, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'RespondToRequest', 'parameters': { 'IdRequest': IdRequest, 'PickUp': PickUp, 'Approved': Approved, 'Rejected': Rejected }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    CheckRequestExistence: function (Email, IdOffer, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'CheckRequestExistence', 'parameters': { 'Email': Email, 'IdOffer': IdOffer }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    CheckRequestPending: function (Email, IdOffer, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'CheckRequestPending', 'parameters': { 'Email': Email, 'IdOffer': IdOffer }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: 'json',
            postData: jsonData,
            headers: { "X-Requested-With": null },
            load: successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },

    GetPassengerNotifications: function (SentRequestsIds, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'GetPassengerNotifications', 'parameters': { 'SentRequestsIds': SentRequestsIds }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: somee ? 'text' : 'json', //8the response shouldn't be handled as json in case it contains html tags, it is handled in someeAdRemover() and returned as a new json object
            postData: jsonData,
            headers: { "X-Requested-With": null },
            //load: successFunction,
            load: somee ? function (response) { successFunction(someeAdRemover(response)); } : successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    GetDriverNotifications: function (Email, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'GetDriverNotifications', 'parameters': { 'Email': Email }, 'token': token };
        
        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: somee ? 'text' : 'json', //8the response shouldn't be handled as json in case it contains html tags, it is handled in someeAdRemover() and returned as a new json object
            postData: jsonData,
            headers: { "X-Requested-With": null },
            //load: successFunction,
            load: somee ? function (response) { successFunction(someeAdRemover(response)); } : successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    GetMenuNotifications: function (Email, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'GetMenuNotifications', 'parameters': { 'Email': Email }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: somee ? 'text' : 'json', //8the response shouldn't be handled as json in case it contains html tags, it is handled in someeAdRemover() and returned as a new json object
            postData: jsonData,
            headers: { "X-Requested-With": null },
            //load: successFunction,
            load: somee ? function (response) { successFunction(someeAdRemover(response)); } : successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    },
    MarkNotificationsAsSeen: function (Email, successFunction, failFunction, token) {
        var data = { 'interface': 'PickrWebService', 'method': 'MarkNotificationsAsSeen', 'parameters': { 'Email': Email }, 'token': token };

        var jsonData = dojo.toJson(data);
        var xhrArgs = {
            url: self.urlString,
            handleAs: somee ? 'text' : 'json', //8the response shouldn't be handled as json in case it contains html tags, it is handled in someeAdRemover() and returned as a new json object
            postData: jsonData,
            headers: { "X-Requested-With": null },
            //load: successFunction,
            load: somee ? function (response) { successFunction(someeAdRemover(response)); } : successFunction,
            error: failFunction
        };
        var deferred = dojo.xhrPost(xhrArgs);
    }


};

