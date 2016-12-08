using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Pickr.Models;
using Pickr.Classes;

namespace Pickr
{
    public class JSONParser
    {

        public bool ParseCreateTable(JObject json)
        {
            bool created = false;
            try
            {
                created = (bool)json["Value"];
            }
            catch (Exception e)
            {
                // TODO Auto-generated catch block
                //Log.d("JSONParser =&amp;gt; parseUserAuth", e.getMessage());
            }

            return created;
        }


        public bool ParseUpdateTable(JObject json)
        {
            bool updated = false;
            try
            {
                updated = (bool)json["Value"];
            }
            catch (Exception e)
            {
                // TODO Auto-generated catch block
                //Log.d("JSONParser =&amp;gt; parseUserAuth", e.getMessage());
            }

            return updated;
        }


        public UserDetails ParseUser(JObject json)
        {
            UserDetails user = new UserDetails();
            Preferences pref = new Preferences();

            try
            {
                JObject jsonUser = (json["Value"][0]).Value<JObject>();
                user.Email = (string) jsonUser["Email"];
                user.Username = (string) jsonUser["Username"];
                user.Password = (string) jsonUser["Password"];

                if (jsonUser["Reputation"] != null)
                    user.Reputation = (int) jsonUser["Reputation"];

                user.CarModel = (string) jsonUser["CarModel"];
                user.FirstName = (string) jsonUser["FirstName"];
                user.Surname = (string) jsonUser["Surname"];

                if (jsonUser["Birth"] != null)
                    user.Birth = (DateTime) jsonUser["Birth"];

                user.Gender = (string) jsonUser["Gender"];
                user.MemberSince = (DateTime)jsonUser["MemberSince"];

                if (jsonUser["Mobile"] != null)
                    user.Mobile = (string)jsonUser["Mobile"];

                user.Picture = (string)jsonUser["Picture"];
                user.Address = (string)jsonUser["Address"];
                user.Mode = (string)jsonUser["Mode"];

                JObject jsonPref = (jsonUser["Preferences"][0]).Value<JObject>();
                pref.Smoking = (bool) jsonPref["Smoking"];
                pref.Music = (bool) jsonPref["Music"];
                pref.Pets = (bool) jsonPref["Pets"];

                //if (jsonUser["Talking"] != null)
                    pref.Talking = (int) jsonPref["Talking"];

                user.Preferences = pref;

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }

            return user;

        }


        public bool ParseUserAuthentication(JObject json)
        {
            bool userAtuh = false;
            try
            {
                userAtuh = (bool)json["Value"];
            }
            catch (Exception e)
            {
                // TODO Auto-generated catch block
                //Log.d("JSONParser =&amp;gt; parseUserAuth", e.getMessage());
            }

            return userAtuh;
        }


        public List<Offer> ParseOffersList(JObject json)
        {
            List<Offer> offers = new List<Offer>();

            try
            {
                
                for (int i = 0; i < json["Value"].Count(); i++)
                {
                    JObject jsonOffer = (json["Value"][i]["Offers"][0]).Value<JObject>();
                    //JObject jsonOffer = (obj).Value<JObject>();
                    Offer o = new Offer();

                    o.OfferId = (int)jsonOffer["IdOffer"];
                    o.UserId = (int)jsonOffer["IdUser"];
                    o.Start.lat = (double)jsonOffer["StartLatitude"];
                    o.Start.lng = (double)jsonOffer["StartLongitude"];
                    o.Destination.lat = (double)jsonOffer["DestinationLatitude"];
                    o.Destination.lng = (double)jsonOffer["DestinationLongitude"];
                    o.Departure = (DateTime)jsonOffer["Departure"];
                    o.Arrival = ((DateTime)jsonOffer["Arrival"]).Year == 1900 ? new DateTime() : (DateTime)jsonOffer["Arrival"];
                    o.Seats = (int)jsonOffer["Seats"];
                    o.ReservedSeats = (int)jsonOffer["ReservedSeats"];
                    o.Price = (int)jsonOffer["Price"];
                    o.Radius = (int)jsonOffer["Radius"];
                    o.Distance = (int)jsonOffer["Distance"];
                    o.Active = (bool)jsonOffer["Active"];

                    
                    List<Coordinates> waypoints = new List<Coordinates>();

                    for (int j = 0; j < jsonOffer["Waypoints"].Count(); j++)
                    {
                        JObject jsonWaypoint = jsonOffer["Waypoints"][j].Value<JObject>();
                        Coordinates coords = new Coordinates();
                        coords.lat = (double)jsonWaypoint["Latitude"];
                        coords.lng = (double)jsonWaypoint["Longitude"];
                        waypoints.Add(coords);
                    }

                    o.Waypoints = waypoints;


                    List<Coordinates> routepoints = new List<Coordinates>();

                    for (int j = 0; j < jsonOffer["RoutePoints"].Count(); j++)
                    {
                        JObject jsonRoutePoint = jsonOffer["RoutePoints"][j].Value<JObject>();
                        Coordinates coords = new Coordinates();
                        coords.lat = (double)jsonRoutePoint["Latitude"];
                        coords.lng = (double)jsonRoutePoint["Longitude"];
                        routepoints.Add(coords);
                    }

                    o.RoutePoints = routepoints;


                    List<Coordinates> rangeIndices = new List<Coordinates>();

                    for (int k = 0; k < jsonOffer["RangeIndices"].Count(); k++)
                    {
                        JObject jsonRangeIndex = jsonOffer["RangeIndices"][k].Value<JObject>();
                        Coordinates coords = new Coordinates();
                        coords.lat = (double)jsonRangeIndex["Latitude"];
                        coords.lng = (double)jsonRangeIndex["Longitude"];
                        rangeIndices.Add(coords);
                    }

                    o.RangeIndices = rangeIndices;

                    offers.Add(o);

                }
                

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }

            return offers;

        }


        public List<Request> ParseRequestsList(JObject json)
        {
            List<Request> requests = new List<Request>();

            try
            {

                for (int i = 0; i < json["Value"].Count(); i++)
                {
                    JObject jsonOffer = (json["Value"][i]["Requests"][0]).Value<JObject>();
                    //JObject jsonOffer = (obj).Value<JObject>();
                    Request r = new Request();

                    r.RequestId = (int)jsonOffer["IdRequest"];
                    r.OfferId = (int)jsonOffer["IdOffer"];
                    r.UserId = (int)jsonOffer["IdUser"];
                    r.Start.lat = (double)jsonOffer["StartLatitude"];
                    r.Start.lng = (double)jsonOffer["StartLongitude"];
                    r.Destination.lat = (double)jsonOffer["DestinationLatitude"];
                    r.Destination.lng = (double)jsonOffer["DestinationLongitude"];
                    r.ArrivalFrom = (DateTime)jsonOffer["ArrivalFrom"];
                    r.ArrivalTo = ((DateTime)jsonOffer["ArrivalTo"]).Year == 1900 ? new DateTime() : (DateTime)jsonOffer["ArrivalTo"];
                    r.Seats = (int)jsonOffer["Seats"];

                    r.PickUp = ((DateTime)jsonOffer["PickUp"]).Year == 1900 ? new DateTime() : (DateTime)jsonOffer["PickUp"];
                    r.Approved = (bool)jsonOffer["Approved"];
                    r.Rejected = (bool)jsonOffer["Rejected"];

                    requests.Add(r);

                }


            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }

            return requests;

        }


        public bool ParseRequestExistence(JObject json)
        {
            bool exists = false;
            try
            {
                exists = (bool)json["Value"];
            }
            catch (Exception e) {}

            return exists;
        }


        public List<Tuple<int, string>> ParsePassengerNotifications(JObject json)
        {
            List<Tuple<int, string>> changedStatuses = new List<Tuple<int, string>>();

            try
            {

                for (int i = 0; i < json["Value"].Count(); i++)
                {
                    JObject jsonOffer = (json["Value"][i][0]).Value<JObject>();
                    
                    Tuple<int,string> r = new Tuple<int, string>( (int)jsonOffer["IdRequest"], (string)jsonOffer["Status"] );
                    changedStatuses.Add(r);

                }


            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }

            return changedStatuses;
        }

    }
}