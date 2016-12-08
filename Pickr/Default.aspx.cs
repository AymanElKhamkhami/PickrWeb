
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

namespace Pickr
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ////Page.ClientScript.RegisterStartupScript(this.GetType(), "Key", "Myfunction();", true);
            //Coordinates location = new Coordinates("51.78589580664769", "19.475841522216797");
            //Coordinates destination = new Coordinates("51.772088988915996", "19.44631576538086");
            //Coordinates start = new Coordinates("51.76475903853143", "19.46399688720703");


            //using (StreamReader r = new StreamReader(Server.MapPath("~/file.json")))
            //{
            //    string json = r.ReadToEnd();
            //    //List<Coordinates> area = JsonConvert.DeserializeObject<List<Coordinates>>(json);
            //    //test.Text = PointInPolygon(location, area).ToString();
            //    List<Coordinates> route = JsonConvert.DeserializeObject<List<Coordinates>>(json);
            //    test.Text = DestinationInSameDirection(start, destination, route).ToString();
            //}

            //RESTfulAPI api = new RESTfulAPI();
            //JSONParser parser = new JSONParser();
            //UserDetails user = new UserDetails();

            //JObject json = api.GetUser("testuser@dmcs.com");
            //user = parser.ParseUserDetails(json);

            HttpContext.Current.Session["test"] = "session is alive";

            if(HttpContext.Current.Session["User"] != null)
            {
                if(((UserDetails)HttpContext.Current.Session["User"]).Mode.Equals("passenger"))
                {
                    Response.Redirect("/PassengerHome");
                }
            }
            


        }

        protected void SearchRide_Click(object sender, EventArgs e)
        {

            HttpContext.Current.Session["SearchedStart"] = searchStart.Value.ToString();
            HttpContext.Current.Session["SearchedDestination"] = searchDest.Value.ToString();
            Response.Redirect("/Account/Login");
        }

        public string SomeeAdRemover(string str)
        {
            int i = str.IndexOf("<");
            return str.Substring(0, i);
        }
        

    }

    
}