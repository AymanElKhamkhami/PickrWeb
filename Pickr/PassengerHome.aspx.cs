
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
using Pickr.Models;
using Pickr.Classes;

namespace Pickr
{
    public partial class PassengerHome : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(HttpContext.Current.Session["SearchedStart"] != null && HttpContext.Current.Session["SearchedDestination"] != null)
            {
                srchStart.Value = HttpContext.Current.Session["SearchedStart"].ToString();
                srchDest.Value = HttpContext.Current.Session["SearchedDestination"].ToString();

                HttpContext.Current.Session["SearchedStart"] = null;
                HttpContext.Current.Session["SearchedDestination"] = null;
            }
        }

        protected void SearchRide_Click(object sender, EventArgs e)
        {
            
            Coordinates start = JsonConvert.DeserializeObject<Coordinates>(StartCoordinates.Value);
            Coordinates destination = JsonConvert.DeserializeObject<Coordinates>(DestinationCoordinates.Value);
            string arrivalFrom = ArrivalF.Value.ToString();
            string arrivalTo = ArrivalT.Value.ToString();

            HttpContext.Current.Session["Start"] = start;
            HttpContext.Current.Session["Destination"] = destination;
            HttpContext.Current.Session["ArrivalFrom"] = arrivalFrom;
            HttpContext.Current.Session["ArrivalTo"] = arrivalTo;

            Response.Redirect("/OfferResults");
        }
    }


    
}