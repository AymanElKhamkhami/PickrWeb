using JSONWebService;
using Newtonsoft.Json.Linq;
using Pickr.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Pickr
{
    public partial class IncomingRequestList : Page
    {
        List<Request> requests;

        protected void Page_Load(object sender, EventArgs e)
        {
            UserDetails user = (UserDetails)HttpContext.Current.Session["User"];
            //requests = (List<Request>)HttpContext.Current.Session["Requests"];
            requests = GetNewReceivedRequests(user.Email);

            TableHeaderRow header = new TableHeaderRow();
            TableHeaderCell headerCell1 = new TableHeaderCell();
            TableHeaderCell headerCell2 = new TableHeaderCell();
            TableHeaderCell headerCell3 = new TableHeaderCell();
            TableHeaderCell headerCell4 = new TableHeaderCell();
            TableHeaderCell headerCell5 = new TableHeaderCell();

            headerCell1.Text = "Request ID";
            headerCell2.Text = "Sent From";
            headerCell3.Text = "Pick-Up/Drop-Off Points";
            headerCell4.Text = "Time";
            headerCell5.Text = "";

            header.Cells.Add(headerCell1);
            header.Cells.Add(headerCell2);
            header.Cells.Add(headerCell3);
            header.Cells.Add(headerCell4);
            header.Cells.Add(headerCell5);

            pendingRequestList.Rows.Add(header);

            if (requests.Count == 0)
                Header.InnerText = "You don't have any pending requests";


            foreach (var item in requests)
            {
                TableRow Row = new TableRow();
                TableCell ReqIds = new TableCell();
                TableCell Requestor = new TableCell();
                TableCell PickUpDropOff = new TableCell();
                TableCell Time = new TableCell();
                TableCell Approve = new TableCell();

                ReqIds.Text = item.RequestId.ToString();
                
                UserDetails requestor = GetUserDetails(item.UserId);
                HyperLink profile = new HyperLink();
                Label address = new Label();
                Image image = new Image();


                image.AlternateText = requestor.FirstName;
                image.CssClass = "img-responsive";
                image.Height = 30;
                image.Width = 30;
                image.ImageUrl = requestor.Picture;
                image.Attributes.Add("Style", "border-radius: 50%; display: inline-block; margin-right: 5px;");

                profile.Text = requestor.FirstName;
                profile.NavigateUrl = "/Account/Profile?id=" + item.UserId;
                address.Text = ", " + requestor.Address;

                Requestor.Controls.Add(image);
                Requestor.Controls.Add(profile);
                Requestor.Controls.Add(address);
                
                Button inf = new Button();
                inf.Attributes.Add("class", "btn btn-primary btn-xs info");
                inf.Text = "See on Map";
                PickUpDropOff.Controls.Add(inf);

                Time.Text = item.Offer.Departure.ToString("dddd").Substring(0, 3) + ", " + item.Offer.Departure.ToString("dd-MM-yyyy") + " from " + item.Offer.Departure.ToString("HH:mm") + " to " + item.Offer.Arrival.ToString("HH:mm");


                Button yes = new Button();
                yes.Attributes.Add("class", "btn btn-success btn-xs approve");
                yes.Text = "Approve";
                //yes.Click += delegate
                //{
                //    //Set pick up time
                //    HttpContext.Current.Session["SelectedId"] = item.RequestId;
                //};

                Button no = new Button();
                no.Attributes.Add("class", "btn btn-default btn-xs reject");
                no.Attributes.Add("style", "margin-left: 10px;");
                no.Text = "Delete Request";
                no.Click += delegate
                {
                    //Remove from list
                    foreach(var r in requests)
                    {
                        if(r.RequestId == item.RequestId)
                        {
                            //Notify requestor of rejected request
                            if(RespondToRequest(r.RequestId, "", false))
                            {
                                requests.Remove(r);
                                HttpContext.Current.Session["Requests"] = requests;
                            }
                            break;
                        }
                    }
                    
                    Response.Redirect("/IncomingRequestList");

                };

                Approve.Controls.Add(yes);
                Approve.Controls.Add(no);

                Row.Cells.Add(ReqIds);
                Row.Cells.Add(Requestor);
                Row.Cells.Add(PickUpDropOff);
                Row.Cells.Add(Time);
                Row.Cells.Add(Approve);

                pendingRequestList.Rows.Add(Row);

            }

        }



        protected void Approve_Click(object sender, EventArgs e)
        {
            int Req = Int32.Parse(SelectedRequest.Value.ToString());
            DateTime PickUp = new DateTime();
            object p;

            foreach (var r in requests)
            {
                if (r.RequestId == Req)
                {
                    PickUp = new DateTime(r.Offer.Departure.Year, r.Offer.Departure.Month, r.Offer.Departure.Day, Int32.Parse(PickUpHour.Value.ToString()), Int32.Parse(PickUpMinute.Value.ToString()), 0);
                }
            }

            if (PickUp != DateTime.MinValue)
                p = PickUp;
            else p = "";

            RespondToRequest(Req, p, true);
            
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


        public bool RespondToRequest(int IdRequest, object PickUp, bool Approved)
        {
            PickrWebService api = new PickrWebService();
            JSONParser parser = new JSONParser();

            JObject json = api.RespondToRequest(IdRequest, PickUp, Approved);

            bool updated = false;
            updated = parser.ParseUpdateTable(json);

            if(updated)
                Response.Redirect("/IncomingRequestList");
                

            if (!updated)
                ErrorMessage.Text = "Error responding to request.";

            return updated;
        }


        public List<Request> GetNewReceivedRequests(string Email)
        {

            PickrWebService api = new PickrWebService();
            JSONParser parser = new JSONParser();
            List<Request> requests = new List<Request>();
            List<Offer> offers = new List<Offer>();

            JObject json = api.GetDriverReceivedRequests(Email, false, false);

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

                //if (requests.Count > 0)
                //{
                //    newRequests.Visible = true;
                //    newRequests.InnerText = requests.Count.ToString();
                //}

                HttpContext.Current.Session["Requests"] = requests;
                HttpContext.Current.Session["RequestedOffers"] = offers;
            }
            catch (Exception e)
            {
                //ErrorMessage.Text = "Error retrieving your list of sent requests.";
            }

            return requests;
        }

    }
}