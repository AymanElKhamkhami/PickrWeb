
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Services;
using Pickr.Models;
using Pickr.Classes;

namespace Pickr
{
    [System.Web.Script.Services.ScriptService]
    public partial class DriverHome : Page
    {
        int OfferId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["Radius"] != null)
            {
                int radius = (int)HttpContext.Current.Session["Radius"];
                if (radius == 1000)
                    rangeValue.Text = "1 km";
                else
                    rangeValue.Text = radius + " m";
            }

            if (Request.QueryString["id"] != null)
            {
                OfferId = Int32.Parse(Request.QueryString["id"]);
                SaveRoute.Text = "Update route";
            }

        }

        public string SomeeAdRemover(string str)
        {
            int i = str.IndexOf("<");
            return str.Substring(0, i);
        }


        public bool PointInPolygon(Coordinates location, List<Coordinates> area)
        {
            //Ray-cast algorithm is here onward
            int k, j = area.Count - 1;
            bool oddNodes = false; //to check whether number of intersections is odd

            for (k = 0; k < area.Count; k++)
            {
                //fetch adjucent points of the polygon
                Coordinates polyK = area[k];
                Coordinates polyJ = area[j];

                //check the intersections
                if (((polyK.lng > location.lng) != (polyJ.lng > location.lng)) &&
                 (location.lat < (polyJ.lat - polyK.lat) * (location.lng - polyK.lng) / (polyJ.lng - polyK.lng) + polyK.lat))
                    oddNodes = !oddNodes; //switch between odd and even
                j = k;
            }

            return oddNodes;
        }

        public bool DestinationInSameDirection(Coordinates start, Coordinates destination, List<Coordinates> route)
        {
            int startIndex = ClosestPointIndex(start, route);
            int destIndex = ClosestPointIndex(destination, route);
            bool b = false;

            if (destIndex > startIndex)
                b = true;

            return b;
        }


        public int ClosestPointIndex(Coordinates x, List<Coordinates> route)
        {
            double distance = (Math.Sqrt(Math.Pow(Math.Abs(x.lat - route[0].lat), 2) + Math.Pow(Math.Abs(x.lng - route[0].lng), 2)));
            int index = 0;

            for (int i = 1; i < route.Count; i++)
            {
                double tempDist;
                tempDist = (Math.Sqrt(Math.Pow(Math.Abs(x.lat - route[i].lat), 2) + Math.Pow(Math.Abs(x.lng - route[i].lng), 2)));

                if (tempDist < distance)
                {
                    distance = tempDist;
                    index = i;
                }
            }

            return index;
        }


        protected void SaveRoute_Click(object sender, EventArgs e)
        {
            List<Coordinates> range = JsonConvert.DeserializeObject<List<Coordinates>>(RangeIndices.Value);
            List<Coordinates> routepoints = JsonConvert.DeserializeObject<List<Coordinates>>(RoutePointsCoordinates.Value);
            List<Coordinates> waypoints = JsonConvert.DeserializeObject<List<Coordinates>>(WaypointsCoordinates.Value);
            Coordinates start = JsonConvert.DeserializeObject<Coordinates>(StartCoordinates.Value);
            Coordinates destination = JsonConvert.DeserializeObject<Coordinates>(DestinationCoordinates.Value);
            int radius = Int32.Parse(Radius.Value.ToString());
            int duration = Int32.Parse(Duration.Value.ToString());

            HttpContext.Current.Session["RangeIndices"] = range;
            HttpContext.Current.Session["RoutePoints"] = routepoints;
            HttpContext.Current.Session["Waypoints"] = waypoints;
            HttpContext.Current.Session["StartCoords"] = start;
            HttpContext.Current.Session["DestCoords"] = destination;
            HttpContext.Current.Session["Radius"] = radius;
            HttpContext.Current.Session["Duration"] = duration;

            if (OfferId>0)
                Response.Redirect("/OfferDetails?id="+OfferId+"&status="+Request.QueryString["status"]);
            else
            Response.Redirect("/OfferDetails");
        }

        //[WebMethod]
        //public static List<Coordinates> GetRouteData(List<Coordinates> routeData)
        //{
        //    return routeData;
        //}

        
    }


   
}