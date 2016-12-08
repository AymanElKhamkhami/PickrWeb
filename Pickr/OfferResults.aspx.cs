using JSONWebService;
using Newtonsoft.Json.Linq;
using Pickr.Models;
using Pickr.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace Pickr
{
    public partial class OfferResults : Page
    {
        UserDetails user;
        List<Offer> filteredResults;

        //User defined variables
        Coordinates start, destination;
        DateTime arrivalFrom;
        object arrivalTo;

        //Offer-related variable
        //Offer selectedOffer;

        protected void Page_Load(object sender, EventArgs e)
        {
            user = (UserDetails)HttpContext.Current.Session["User"];
            HttpContext.Current.Session["Results"] = new List<Offer>() { new Offer() };

            //Initialiaze Results table headers
            TableHeaderRow header = new TableHeaderRow();
            TableHeaderCell headerCell1 = new TableHeaderCell();
            TableHeaderCell headerCell2 = new TableHeaderCell();
            TableHeaderCell headerCell3 = new TableHeaderCell();
            TableHeaderCell headerCell4 = new TableHeaderCell();
            TableHeaderCell headerCell5 = new TableHeaderCell();
            TableHeaderCell headerCell6 = new TableHeaderCell();
            TableHeaderCell headerCell7 = new TableHeaderCell();

            headerCell1.Text = "Offer ID";
            headerCell2.Text = "Scheduled Departure";
            headerCell3.Text = "Driver";
            headerCell4.Text = "Available Seats";
            headerCell5.Text = "Price (Per Seat)";
            headerCell6.Text = "";
            headerCell7.Text = "";

            header.Cells.Add(headerCell1);
            header.Cells.Add(headerCell2);
            header.Cells.Add(headerCell3);
            header.Cells.Add(headerCell4);
            header.Cells.Add(headerCell5);
            header.Cells.Add(headerCell6);
            header.Cells.Add(headerCell7);

            offersList.Rows.Add(header);



            if (HttpContext.Current.Session["Start"] != null && HttpContext.Current.Session["Destination"] != null && HttpContext.Current.Session["ArrivalFrom"] != null && HttpContext.Current.Session["ArrivalTo"] != null)
            {
                start = (Coordinates) HttpContext.Current.Session["Start"];
                destination = (Coordinates)HttpContext.Current.Session["Destination"];
                arrivalFrom = Convert.ToDateTime(HttpContext.Current.Session["ArrivalFrom"].ToString());
                if (String.IsNullOrEmpty(HttpContext.Current.Session["ArrivalTo"].ToString()))  arrivalTo = "";
                else arrivalTo = Convert.ToDateTime(HttpContext.Current.Session["ArrivalTo"].ToString());

                List<Offer> results = GetSearchResults(arrivalFrom, arrivalTo, start.lat, start.lng, destination.lat, destination.lng);
                HttpContext.Current.Session["RawResults"] = results;
                filteredResults = new List<Offer>();

                if(results.Count > 0)
                {
                    foreach (var o in results)
                    {
                        bool startInRange = PointInPolygon(start, o.RangeIndices);
                        bool destinationInRange = PointInPolygon(destination, o.RangeIndices);
                        bool pointsInSameDirection = DestinationInSameDirection(start, destination, o.RoutePoints);

                        if (startInRange && destinationInRange && pointsInSameDirection)
                            filteredResults.Add(o);
                    }
                }
                

                if (filteredResults.Count == 0)
                {
                    Header.InnerText = "No offered rides meet your search criteria";
                    Notify.Visible = true;
                    Notify.Click += delegate
                    {
                        SendRequest(user.Email, "", start.lat, start.lng, destination.lat, destination.lng, arrivalFrom, arrivalTo, 0);
                    };
                }


                HttpContext.Current.Session["Results"] = filteredResults;


                foreach (var item in filteredResults)
                {
                    TableRow Row = new TableRow();
                    TableCell Ids = new TableCell();
                    TableCell ScheduledDeparture = new TableCell();
                    TableCell Driver = new TableCell();
                    TableCell Seats = new TableCell();
                    TableCell Price = new TableCell();
                    TableCell Info = new TableCell();
                    TableCell Request = new TableCell();

                    Ids.Text = item.OfferId.ToString();
                    ScheduledDeparture.Text = item.Departure.ToString("dddd").Substring(0, 3) + ", " + item.Departure.ToString("dd-MM-yyyy") + " at " + item.Departure.ToString("HH:mm");// + " at " + item.Departure.Hour +":"+item.Departure.Minute;

                    UserDetails driver = GetUserDetails(item.UserId);
                    HyperLink profile = new HyperLink();
                    Label car = new Label();

                    profile.Text = driver.FirstName;
                    profile.NavigateUrl = "/Account/Profile?id="+item.UserId;
                    car.Text = " (" + driver.CarModel + ")";

                    Driver.Controls.Add(profile);
                    Driver.Controls.Add(car);

                    Seats.Text = item.Seats.ToString();
                    Price.Text = item.Price.ToString() + " PLN";

                    Button inf = new Button();
                    inf.Attributes.Add("class", "btn btn-primary btn-xs info");
                    inf.Text = "See on Map";
                    Info.Controls.Add(inf);
                    
                    
                    Button req = new Button();
                    req.Attributes.Add("class", "btn btn-warning btn-xs open");
                    req.Text = new String(' ',3) + "Send a Request" + new String(' ',3);
                    req.Click += delegate
                    {
                        HttpContext.Current.Session["SelectedId"] = item.OfferId;
                    };

                    Button pending = new Button();
                    pending.Attributes.Add("class", "btn btn-warning disabled btn-xs");
                    pending.OnClientClick = "return false;";
                    pending.Text = new String(' ',4) + "Request Sent" + new String(' ', 4);

                    if (CheckRequestPending(user.Email, item.OfferId))
                        Request.Controls.Add(pending);
                    
                     if(!CheckRequestExistence(user.Email, item.OfferId) && !CheckRequestPending(user.Email, item.OfferId))
                        Request.Controls.Add(req);

                    //If a request was previously sent and was rejected or approved
                    if(CheckRequestExistence(user.Email, item.OfferId) && !CheckRequestPending(user.Email, item.OfferId))
                    {
                        pending.Text = "Approved / Rejected";
                        Request.Controls.Add(pending);
                    }
                    

                    Row.Cells.Add(Ids);
                    Row.Cells.Add(ScheduledDeparture);
                    Row.Cells.Add(Driver);
                    Row.Cells.Add(Seats);
                    Row.Cells.Add(Price);
                    Row.Cells.Add(Info);
                    Row.Cells.Add(Request);

                    offersList.Rows.Add(Row);

                }

            }

            
        }


        protected void Send_Click(object sender, EventArgs e)
        {
            SendRequest(user.Email, Int32.Parse(SelectedOffer.Value.ToString()), start.lat, start.lng, destination.lat, destination.lng, arrivalFrom, arrivalTo, Int32.Parse(Seats.Text.ToString()));
        }


        public List<Offer> GetSearchResults(DateTime ArrivalFrom, object ArrivalTo, double StartLat, double StartLng, double DestinationLat, double DestinationLng)
        {

            PickrWebService api = new PickrWebService();
            JSONParser parser = new JSONParser();
            List<Offer> results = new List<Offer>();

            JObject json = api.SearchRides(ArrivalFrom, ArrivalTo, StartLat, StartLng, DestinationLat, DestinationLng);
            
            try
            {
                results = parser.ParseOffersList(json);
            }
            catch (Exception e)
            {
                ErrorMessage.Text = "Error getting search results.";
            }

            return results;
        }
        
        
        public UserDetails GetUserDetails(int IdUser)
        {
            PickrWebService api = new PickrWebService();
            JSONParser parser = new JSONParser();
            UserDetails user = new UserDetails();

            JObject json = api.GetUserPublic(IdUser);

            try
            {
                user = parser.ParseUser(json);
            }
            catch (Exception e)
            {
                ErrorMessage.Text = "Error getting user data.";
            }

            return user;
        }


        public List<Request> GetSentRequests(string Email)
        {

            PickrWebService api = new PickrWebService();
            JSONParser parser = new JSONParser();
            List<Request> requests = new List<Request>();
            List<Offer> offers = new List<Offer>();

            JObject json = api.GetPassengerSentRequests(Email);

            try
            {
                requests = parser.ParseRequestsList(json);
                List<int> offerIds = new List<int>();

                foreach (Request r in requests)
                    offerIds.Add(r.OfferId);

                if (requests.Count > 0)
                {
                    json = api.GetRequestedOffersList(offerIds);
                    offers = parser.ParseOffersList(json);

                    foreach (var r in requests)
                        foreach (var o in offers)
                            if (r.OfferId == o.OfferId)
                                r.Offer = o;

                }


                HttpContext.Current.Session["SentRequests"] = requests;
            }
            catch (Exception e)
            {
                ErrorMessage.Text = "Error retrieving your list of sent requests.";
            }

            return requests;
        }


        public bool CheckRequestExistence(string Email, int IdOffer)
        {
            PickrWebService api = new PickrWebService();
            JSONParser parser = new JSONParser();

            JObject json = api.CheckRequestExistence(Email, IdOffer);

            return parser.ParseCreateTable(json);
        }


        public bool CheckRequestPending(string Email, int IdOffer)
        {
            PickrWebService api = new PickrWebService();
            JSONParser parser = new JSONParser();

            JObject json = api.CheckRequestPending(Email, IdOffer);

            return parser.ParseCreateTable(json);
        }


        public void SendRequest(string Email, object IdOffer, double StartLat, double StartLng, double DestinationLat, double DestinationLng, DateTime ArrivalFrom, object ArrivalTo, int Seats)
        {
            PickrWebService api = new PickrWebService();
            JSONParser parser = new JSONParser();
            
            JObject json = api.CreateRequest(Email, IdOffer, StartLat, StartLng, DestinationLat, DestinationLng, ArrivalFrom, ArrivalTo, Seats);
            
            bool added = false;
            added = parser.ParseCreateTable(json);

            if (added)
            {
                GetSentRequests(Email);
                Response.Redirect("/RequestList");
            }

            else if (!added)
            {
                ErrorMessage.Text = "This request could not be sent. Make sure you haven't already sent a request.";
            }
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

    }
}