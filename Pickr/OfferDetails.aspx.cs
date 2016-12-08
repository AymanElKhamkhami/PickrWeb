using JSONWebService;
using Newtonsoft.Json.Linq;
using Pickr.Classes;
using Pickr.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Pickr
{
    public partial class OfferDetails : Page
    {
        List<Coordinates> range;
        List<Coordinates> routepoints;
        List<Coordinates> waypoints;
        Coordinates start;
        Coordinates destination;
        int radius;
        int duration;
        int OfferId;

        protected void Page_Load(object sender, EventArgs e)
        {
            Save.Visible = false;
            editRoute.NavigateUrl = "/DriverHome.aspx";
            //Price.Attributes.Add("onkeypress", "checkDecimal()");
            //Price.Attributes.Add("onkeyup", "checkDecimal()");
            //Price.Attributes.Add("onchange", "checkDecimal()");

            if (HttpContext.Current.Session["RangeIndices"] != null && HttpContext.Current.Session["Waypoints"] != null && HttpContext.Current.Session["RoutePoints"] != null && HttpContext.Current.Session["StartCoords"] != null && HttpContext.Current.Session["DestCoords"] != null && HttpContext.Current.Session["Radius"] != null && HttpContext.Current.Session["Duration"] != null)
            {
                range = (List<Coordinates>)HttpContext.Current.Session["RangeIndices"];
                routepoints = (List<Coordinates>)HttpContext.Current.Session["RoutePoints"];
                waypoints = (List<Coordinates>)HttpContext.Current.Session["Waypoints"];
                start = (Coordinates)HttpContext.Current.Session["StartCoords"];
                destination = (Coordinates)HttpContext.Current.Session["DestCoords"];
                radius = (int)HttpContext.Current.Session["Radius"];
                duration = (int)HttpContext.Current.Session["Duration"];

                //HttpContext.Current.Session["RangeIndices"] = null;
                //HttpContext.Current.Session["Waypoints"] = null;
                //HttpContext.Current.Session["StartCoords"] = null;
                //HttpContext.Current.Session["DestCoords"] = null;
                //HttpContext.Current.Session["Radius"] = null;
                //HttpContext.Current.Session["Duration"] = null;
            }

            if(Request.QueryString["id"] == null && !IsPostBack)
            {
                //DepartureTime.Text = DateTime.Now.ToLocalTime().ToString("yyyy-MM-ddTHH:mm");
                //DepartureDate.Value = DateTime.Now.ToLocalTime().ToString();
            }

            if(Request.QueryString["id"] != null)
            {
                OfferId = Int32.Parse(Request.QueryString["id"]);
                string status = Request.QueryString["status"];
                editRoute.NavigateUrl = "/DriverHome.aspx?id=" + OfferId + "&status=" + status;
                
                if (status.Equals("Expired") || status.Equals("Scheduled"))
                {
                    Publish.Visible = false;
                    editRoute.Visible = false;
                    //DepartureTime.Enabled = false;
                    DepartureDate.Attributes.Add("disabled", "true");
                    timeHolder.Attributes.Add("disabled", "true");
                    hour.Attributes.Add("disabled", "true");
                    minute.Attributes.Add("disabled", "true");
                    checkMultiple.Visible = false;

                    Seats.Enabled = false;
                    Price.Enabled = false;
                    detailsTitle.InnerText = "Journey Details";

                    
                }

                if (status.Equals("Active"))
                {
                    checkMultiple.Visible = false;

                    Publish.Visible = false;
                    Save.Visible = true;
                }
                    

                if (!IsPostBack)
                {
                    //DepartureTime.Text = ((DateTime)HttpContext.Current.Session["Departure"]).ToString("yyyy-MM-ddTHH:mm");
                    DateTime sessionDeparture = (DateTime)HttpContext.Current.Session["Departure"];
                    HiddenDate.Value = sessionDeparture.ToString("MM/dd/yyyy");
                    HiddenHour.Value = sessionDeparture.ToString("HH:mm").Split(':')[0];
                    HiddenMinute.Value = sessionDeparture.ToString("HH:mm").Split(':')[1];

                    Seats.Text = ((int)HttpContext.Current.Session["Seats"]).ToString();
                    Price.Text = ((double)HttpContext.Current.Session["Price"]).ToString();
                }
                

            }
            

        }

        protected void Publish_Click(object sender, EventArgs e)
        {
            bool allAdded = true;

            string[] multipleDates = DepartureDate.Value.ToString().Split(',');

            foreach(var d in multipleDates)
            {
                string[] date = d.Split('/');
                int hr = Int32.Parse(hour.Value.ToString());
                int min = Int32.Parse(minute.Value.ToString());

                DateTime departure = new DateTime(Int32.Parse(date[2]), Int32.Parse(date[0]), Int32.Parse(date[1]), hr, min, 0);
                //DateTime departure = Convert.ToDateTime(DepartureTime.Text);

                DateTime arrival = departure.AddMinutes(duration);
                int seats = Int32.Parse(Seats.Text.ToString());
                double price = Double.Parse(Price.Text.ToString());

                double dist = Double.Parse(Distance.Value.ToString());

                //double dist = Double.Parse(distance.ToString().Substring(0, distance.ToString().Length - 3));

                UserDetails u = (UserDetails)HttpContext.Current.Session["User"];
                List<List<double>> wyptsLst = new List<List<double>>();
                List<List<double>> rtptsLst = new List<List<double>>();
                List<List<double>> rngPtsLst = new List<List<double>>();

                foreach (var wypt in waypoints)
                {
                    List<double> coords = new List<double>();
                    coords.Add(wypt.lat);
                    coords.Add(wypt.lng);
                    wyptsLst.Add(coords);
                }

                foreach (var rtpt in routepoints)
                {
                    List<double> coords = new List<double>();
                    coords.Add(rtpt.lat);
                    coords.Add(rtpt.lng);
                    rtptsLst.Add(coords);
                }

                foreach (var rngPt in range)
                {
                    List<double> coords = new List<double>();
                    coords.Add(rngPt.lat);
                    coords.Add(rngPt.lng);
                    rngPtsLst.Add(coords);
                }

                allAdded = allAdded & CreateRideOffer(u.Email, start.lat, start.lng, destination.lat, destination.lng, wyptsLst, rtptsLst, rngPtsLst, departure, arrival, seats, price, radius, dist, true);

            }

            if(allAdded)
            {
                HttpContext.Current.Session["RangeIndices"] = null;
                HttpContext.Current.Session["RoutePoints"] = null;
                HttpContext.Current.Session["Waypoints"] = null;
                HttpContext.Current.Session["StartCoords"] = null;
                HttpContext.Current.Session["DestCoords"] = null;
                HttpContext.Current.Session["Radius"] = null;
                HttpContext.Current.Session["Duration"] = null;
                Response.Redirect("/OffersList");
            }

            else
                ErrorMessage.Text = "Some data was not successfully published.";

        }


        protected void Save_Click(object sender, EventArgs e)
        {
            
            string[] date = DepartureDate.Value.ToString().Split('/');
            int hr = Int32.Parse(hour.Value.ToString());
            int min = Int32.Parse(minute.Value.ToString());

            DateTime departure = new DateTime(Int32.Parse(date[2]), Int32.Parse(date[0]), Int32.Parse(date[1]), hr, min, 0);
            duration = Int32.Parse(Dur.Value.ToString());
            DateTime arrival = departure.AddMinutes(duration);
            int seats = Int32.Parse(Seats.Text.ToString());
            double price = Double.Parse(Price.Text.ToString());
            double dist = Double.Parse(Distance.Value.ToString());

            //double dist = Double.Parse(distance.ToString().Substring(0, distance.ToString().Length - 3));

            UserDetails u = (UserDetails)HttpContext.Current.Session["User"];
            List<List<double>> wyptsLst = new List<List<double>>();
            List<List<double>> rtptsLst = new List<List<double>>();
            List<List<double>> rngPtsLst = new List<List<double>>();

            foreach (var wypt in waypoints)
            {
                List<double> coords = new List<double>();
                coords.Add(wypt.lat);
                coords.Add(wypt.lng);
                wyptsLst.Add(coords);
            }

            foreach (var rtpt in routepoints)
            {
                List<double> coords = new List<double>();
                coords.Add(rtpt.lat);
                coords.Add(rtpt.lng);
                rtptsLst.Add(coords);
            }

            foreach (var rngPt in range)
            {
                List<double> coords = new List<double>();
                coords.Add(rngPt.lat);
                coords.Add(rngPt.lng);
                rngPtsLst.Add(coords);
            }

            UpdateRideOffer(OfferId, start.lat, start.lng, destination.lat, destination.lng, wyptsLst, rtptsLst, rngPtsLst, departure, arrival, seats, price, radius, dist);
            

        }


        public bool CreateRideOffer(string Email, double StartLat, double StartLng, double DestinationLat, double DestinationLng, List<List<double>> Waypoints, List<List<double>> RoutePoints, List<List<double>> RangePolygon, DateTime Departure, object Arrival, int Seats, double Price, int Radius, double Distance, bool Active)
        {
            PickrWebService api = new PickrWebService();
            JSONParser parser = new JSONParser();
            Offer o = new Offer();

            JObject json = api.CreateOffer(Email, StartLat, StartLng, DestinationLat, DestinationLng, Waypoints, RoutePoints, RangePolygon, Departure, Arrival, Seats, Price, Radius, Distance, Active);

            
            bool added = false;
            added = parser.ParseCreateTable(json);

            if (added)
            {
                //HttpContext.Current.Session["RangeIndices"] = null;
                //HttpContext.Current.Session["RoutePoints"] = null;
                //HttpContext.Current.Session["Waypoints"] = null;
                //HttpContext.Current.Session["StartCoords"] = null;
                //HttpContext.Current.Session["DestCoords"] = null;
                //HttpContext.Current.Session["Radius"] = null;
                //HttpContext.Current.Session["Duration"] = null;
                //Response.Redirect("/OffersList");
                
            }

            //else if (!added)
            //{
            //    ErrorMessage.Text = "Some data was not successfully published.";
            //}

            return added;
        }


        public void UpdateRideOffer(int OfferId, double StartLat, double StartLng, double DestinationLat, double DestinationLng, List<List<double>> Waypoints, List<List<double>> RoutePoints, List<List<double>> RangePolygon, DateTime Departure, object Arrival, int Seats, double Price, int Radius, double Distance)
        {
            PickrWebService api = new PickrWebService();
            JSONParser parser = new JSONParser();
            Offer o = new Offer();

            JObject json = api.UpdateOffer(OfferId, StartLat, StartLng, DestinationLat, DestinationLng, Waypoints, RoutePoints, RangePolygon, Departure, Arrival, Seats,"", Price, Radius, Distance,"");
            //JObject json = api.UpdateOffer(31, 51.7718765433365, 19.4439125061035, 51.7474386311757, 19.4500923156738, new List<List<double>>(), new List<List<double>>(), "2016-08-30T10:46:00", "", 1, "", 10.5, 600, 3.4, "");


            bool updated = false;
            updated = parser.ParseUpdateTable(json);

            if (updated)
            {
                HttpContext.Current.Session["RangeIndices"] = null;
                HttpContext.Current.Session["RoutePoints"] = null;
                HttpContext.Current.Session["Waypoints"] = null;
                HttpContext.Current.Session["StartCoords"] = null;
                HttpContext.Current.Session["DestCoords"] = null;
                HttpContext.Current.Session["Radius"] = null;
                HttpContext.Current.Session["Duration"] = null;
                Response.Redirect("/OffersList");

            }

            else if (!updated)
            {
                ErrorMessage.Text = "This ride offer was not successfully updated.";
            }

        }

    }
}