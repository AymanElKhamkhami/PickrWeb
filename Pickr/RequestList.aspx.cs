using JSONWebService;
using Newtonsoft.Json.Linq;
using Pickr.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Pickr
{
    public partial class RequestList : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            UserDetails user = (UserDetails)HttpContext.Current.Session["User"];

            List<Request> requests = GetRequests(user.Email);

            TableHeaderRow header = new TableHeaderRow();
            TableHeaderCell headerCell1 = new TableHeaderCell();
            TableHeaderCell headerCell2 = new TableHeaderCell();
            TableHeaderCell headerCell3 = new TableHeaderCell();
            TableHeaderCell headerCell4 = new TableHeaderCell();
            TableHeaderCell headerCell5 = new TableHeaderCell();
            TableHeaderCell headerCell6 = new TableHeaderCell();

            headerCell1.Text = "Request ID";
            headerCell2.Text = "Status";
            headerCell3.Text = "Driver";
            headerCell4.Text = "Time";
            headerCell5.Text = "Pickup Time";
            headerCell6.Text = "Journey Details";

            header.Cells.Add(headerCell1);
            header.Cells.Add(headerCell2);
            header.Cells.Add(headerCell3);
            header.Cells.Add(headerCell4);
            header.Cells.Add(headerCell5);
            header.Cells.Add(headerCell6);

            sentRequestList.Rows.Add(header);


            if (requests.Count == 0)
                Header.InnerText = "You don't have any sent or pending requests";


            foreach (var item in requests)
            {
                TableRow Row = new TableRow();
                TableCell ReqIds = new TableCell();
                TableCell Status = new TableCell();
                TableCell Driver = new TableCell();
                TableCell Time = new TableCell();
                TableCell PickUpTime = new TableCell();
                TableCell Details = new TableCell();

                ReqIds.Text = item.RequestId.ToString();

                if (item.Approved)
                {
                    Status.Text = "Approved";
                    Row.Attributes.Add("class", "success");
                }

                if (!item.Approved)
                {
                    Status.Text = "Pending";
                }

                if(item.Rejected)
                {
                    Status.Text = "Rejected";
                    Row.Attributes.Add("class", "danger");
                }

                UserDetails driver = GetUserDetails(item.Offer.UserId);
                HyperLink profile = new HyperLink();
                Label car = new Label();
                Image image = new Image();


                image.AlternateText = driver.FirstName;
                image.CssClass = "img-responsive";
                image.Height = 30;
                image.Width = 30;
                image.ImageUrl = driver.Picture;
                image.Attributes.Add("Style", "border-radius: 50%; display: inline-block; margin-right: 5px;");


                profile.Text = driver.FirstName;
                profile.NavigateUrl = "/Account/Profile?id=" + item.Offer.UserId;
                car.Text = " (" + driver.CarModel + ")";

                Driver.Controls.Add(image);
                Driver.Controls.Add(profile);
                Driver.Controls.Add(car);
                
                Time.Text = item.Offer.Departure.ToString("dddd").Substring(0, 3) + ", " + item.Offer.Departure.ToString("dd-MM-yyyy") + " from " + item.Offer.Departure.ToString("HH:mm") + " to " + item.Offer.Arrival.ToString("HH:mm");

                PickUpTime.Text = item.PickUp == DateTime.MinValue ? "--" : item.PickUp.ToString("HH:mm");

                Button inf = new Button();
                inf.Attributes.Add("class", "btn btn-primary btn-xs info");
                inf.Text = "See on Map";
                Details.Controls.Add(inf);
                
                Row.Cells.Add(ReqIds);
                Row.Cells.Add(Status);
                Row.Cells.Add(Driver);
                Row.Cells.Add(Time);
                Row.Cells.Add(PickUpTime);
                Row.Cells.Add(Details);

                sentRequestList.Rows.Add(Row);

            }

        }


        public List<Request> GetRequests(string Email)
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
                    
                    foreach(var r in requests)
                        foreach(var o in offers)
                            if (r.OfferId == o.OfferId)
                                r.Offer = o;

                }
                

                HttpContext.Current.Session["Requests"] = requests;
            }
            catch (Exception e)
            {
                ErrorMessage.Text = "Error retrieving your list of sent requests.";
            }

            return requests;
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

        

    }
}