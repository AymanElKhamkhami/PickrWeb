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
    public partial class OffersList : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            UserDetails user = (UserDetails)HttpContext.Current.Session["User"];
            List<Offer> offers = GetOffers(user.Email);

            TableHeaderRow header = new TableHeaderRow();
            TableHeaderCell headerCell1 = new TableHeaderCell();
            TableHeaderCell headerCell2 = new TableHeaderCell();
            TableHeaderCell headerCell3 = new TableHeaderCell();
            TableHeaderCell headerCell4 = new TableHeaderCell();
            TableHeaderCell headerCell5 = new TableHeaderCell();
            TableHeaderCell headerCell6 = new TableHeaderCell();

            headerCell1.Text = "Offer ID";
            headerCell2.Text = "Due Date";
            headerCell3.Text = "Passenger";
            headerCell4.Text = "Status";
            headerCell5.Text = "Details";
            headerCell6.Text = "";

            header.Cells.Add(headerCell1);
            header.Cells.Add(headerCell2);
            header.Cells.Add(headerCell3);
            header.Cells.Add(headerCell4);
            header.Cells.Add(headerCell5);
            header.Cells.Add(headerCell6);

            offersList.Rows.Add(header);


            foreach (var item in offers)
            {
                TableRow Row = new TableRow();
                TableCell Ids = new TableCell();
                TableCell DueDate = new TableCell();
                TableCell Passenger = new TableCell();
                TableCell Status = new TableCell();
                TableCell Details = new TableCell();
                TableCell Delete = new TableCell();

                Ids.Text = item.OfferId.ToString();
                DueDate.Text = item.Departure.ToString("dddd").Substring(0, 3) + ", " + item.Departure.ToString("dd-MM-yyyy") + " at " + item.Departure.ToString("HH:mm");// + " at " + item.Departure.Hour +":"+item.Departure.Minute;

                



                if (item.ReservedSeats > 0 && item.Active)
                {
                    Status.Text = "Scheduled";
                    Row.Attributes.Add("class", "success");


                    List<Request> requests = GetApprovedRequests(user.Email);
                    UserDetails passenger;

                    foreach (var r in requests)
                    {
                        if (r.OfferId == item.OfferId && r.Approved)
                        {
                            passenger = GetUserDetails(r.UserId);
                            HyperLink profile = new HyperLink();
                            Label address = new Label();
                            Image image = new Image();


                            image.AlternateText = passenger.FirstName;
                            image.CssClass = "img-responsive";
                            image.Height = 30;
                            image.Width = 30;
                            image.ImageUrl = passenger.Picture;
                            image.Attributes.Add("Style", "border-radius: 50%; display: inline-block; margin-right: 5px;");
                              
                            profile.Text = passenger.FirstName;
                            profile.NavigateUrl = "/Account/Profile?id=" + r.UserId;
                            address.Text = ", " + passenger.Address;

                            Passenger.Controls.Add(image);
                            Passenger.Controls.Add(profile);
                            Passenger.Controls.Add(address);
                        }
                    }
                }

                if (!item.Active)
                {
                    Status.Text = "Expired";
                    Row.Attributes.Add("class", "warning");
                }

                if ((item.ReservedSeats == 0) && item.Active)
                    Status.Text = "Active";

                Button det = new Button();
                det.Attributes.Add("class", "btn btn-primary btn-xs");
                det.Text = "Details";
                det.Click += delegate
                {
                    HttpContext.Current.Session["Waypoints"] = item.Waypoints;
                    HttpContext.Current.Session["RoutePoints"] = item.RoutePoints;
                    HttpContext.Current.Session["RangeIndices"] = item.RangeIndices;
                    HttpContext.Current.Session["StartCoords"] = item.Start;
                    HttpContext.Current.Session["DestCoords"] = item.Destination;
                    HttpContext.Current.Session["Radius"] = item.Radius;
                    HttpContext.Current.Session["Duration"] = 0;

                    HttpContext.Current.Session["Departure"] = item.Departure;
                    HttpContext.Current.Session["Seats"] = item.Seats;
                    HttpContext.Current.Session["Price"] = item.Price;

                    Response.Redirect("/OfferDetails?id=" + item.OfferId + "&status=" + Status.Text);
                };

                Details.Controls.Add(det);

                LinkButton del = new LinkButton();
                del.Attributes.Add("style", "text-decoration:none;");

                if (!Status.Text.ToString().Equals("Scheduled"))
                {
                    del.Attributes.Add("class", "fa fa-trash fa-2x iconbutton");
                    del.Click += delegate
                    {
                        DeleteOffer(item.OfferId);
                        Response.Redirect("/OffersList");
                    };
                }

                if (Status.Text.ToString().Equals("Scheduled"))
                {
                    del.Attributes.Add("class", "fa fa-trash fa-2x disablediconbutton");
                    del.Enabled = false;
                }

                Delete.Controls.Add(del);


                Row.Cells.Add(Ids);
                Row.Cells.Add(DueDate);
                Row.Cells.Add(Passenger);
                Row.Cells.Add(Status);
                Row.Cells.Add(Details);
                Row.Cells.Add(Delete);

                offersList.Rows.Add(Row);

            }

        }





        public List<Offer> GetOffers(string Email)
        {

            PickrWebService api = new PickrWebService();
            JSONParser parser = new JSONParser();
            List<Offer> offers = new List<Offer>();

            JObject json = api.GetOffersList(Email);

            try
            {
                offers = parser.ParseOffersList(json);
                HttpContext.Current.Session["Offers"] = offers;
            }
            catch (Exception e)
            {
                ErrorMessage.Text = "Error retrieving your list of offers.";
            }

            return offers;
        }


        public List<Request> GetApprovedRequests(string Email)
        {

            PickrWebService api = new PickrWebService();
            JSONParser parser = new JSONParser();
            List<Request> requests = new List<Request>();
            JObject json = api.GetDriverReceivedRequests(Email, true, false);

            requests = parser.ParseRequestsList(json);

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


        public void DeleteOffer(int IdOffer)
        {
            PickrWebService api = new PickrWebService();
            JSONParser parser = new JSONParser();

            JObject json = api.DeleteOffer(IdOffer);

            try
            {
                bool deleted = parser.ParseUpdateTable(json);
                if (!deleted) ErrorMessage.Text = "Error deleting offer.";

            }
            catch (Exception e)
            {
                ErrorMessage.Text = "Error deleting offer.";
            }
        }
    }
}