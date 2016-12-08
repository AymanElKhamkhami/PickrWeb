using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Security.Principal;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Identity;
using Pickr.Models;
using System.Web.SessionState;
using JSONWebService;
using Newtonsoft.Json.Linq;
using System.Threading;

namespace Pickr
{
    public partial class SiteMaster : MasterPage
    {
        private const string AntiXsrfTokenKey = "__AntiXsrfToken";
        private const string AntiXsrfUserNameKey = "__AntiXsrfUserName";
        private string _antiXsrfTokenValue;
        

        protected void Page_Init(object sender, EventArgs e)
        {
            
            // The code below helps to protect against XSRF attacks
            var requestCookie = Request.Cookies[AntiXsrfTokenKey];
            Guid requestCookieGuidValue;
            if (requestCookie != null && Guid.TryParse(requestCookie.Value, out requestCookieGuidValue))
            {
                // Use the Anti-XSRF token from the cookie
                _antiXsrfTokenValue = requestCookie.Value;
                Page.ViewStateUserKey = _antiXsrfTokenValue;
            }
            else
            {
                // Generate a new Anti-XSRF token and save to the cookie
                _antiXsrfTokenValue = Guid.NewGuid().ToString("N");
                Page.ViewStateUserKey = _antiXsrfTokenValue;

                var responseCookie = new HttpCookie(AntiXsrfTokenKey)
                {
                    HttpOnly = true,
                    Value = _antiXsrfTokenValue
                };
                if (FormsAuthentication.RequireSSL && Request.IsSecureConnection)
                {
                    responseCookie.Secure = true;
                }
                Response.Cookies.Set(responseCookie);
            }

            Page.PreLoad += master_Page_PreLoad;

        }


        protected void master_Page_PreLoad(object sender, EventArgs e)
        {
            
            if (!IsPostBack)
            {
                // Set Anti-XSRF token
                ViewState[AntiXsrfTokenKey] = Page.ViewStateUserKey;
                ViewState[AntiXsrfUserNameKey] = Context.User.Identity.Name ?? String.Empty;

                //if (HttpContext.Current.Session["User"] == null)
                //{
                //    Context.GetOwinContext().Authentication.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
                //}
            }
            else
            {
                // Validate the Anti-XSRF token
                if ((string)ViewState[AntiXsrfTokenKey] != _antiXsrfTokenValue
                    || (string)ViewState[AntiXsrfUserNameKey] != (Context.User.Identity.Name ?? String.Empty))
                {
                    throw new InvalidOperationException("Validation of Anti-XSRF token failed.");
                }
            }



        }


        protected void Page_Load(object sender, EventArgs e)
        {
            Sep.Visible = false;
            Sep2.Visible = false;
            driverMode.Visible = false;
            passengerMode.Visible = false;
            HomeLink.Visible = false;
            offersList.Visible = false;
            requestsList.Visible = false;
            incomingRequestsList.Visible = false;
            notifsBell.Visible = false;


            string pageName = Page.Title;
            UserDetails usr = (UserDetails)HttpContext.Current.Session["User"];
            

            //Automatic logout to prevent using the OwinContext user to login if the session is lost
            if (!String.IsNullOrEmpty(Page.User.Identity.Name) && usr == null)
            {
                FormsAuthentication.SignOut();
                HttpContext.Current.User = new GenericPrincipal(new GenericIdentity(string.Empty), null);
            }

            

            switch (pageName)
            { 
                case "Log in":
                    if(usr != null && usr.Mode.Equals("passenger"))
                        Response.Redirect("/PassengerHome");
                    if (usr != null && usr.Mode.Equals("driver"))
                        Response.Redirect("/DriverHome");
                    break;

                case "Default Home Page":
                    if (usr != null && usr.Mode.Equals("passenger"))
                        Response.Redirect("/PassengerHome");
                    if (usr != null && usr.Mode.Equals("driver"))
                        Response.Redirect("/DriverHome");
                    break;

                case "Home Page":
                    //HomeLink.Style.Add("color", "black");
                    break;
        
                default:
                    break; 
            }



        }


        protected void Page_PreRender(object sender, EventArgs e)
        {
            
            if ( HttpContext.Current.Session["User"] != null)
            {
                UserDetails user = (UserDetails)HttpContext.Current.Session["User"];
                
                HomeLink.Visible = true;
                AboutLink.Visible = false;
                ContactLink.Visible = false;
                Sep.Visible = true;
                Sep2.Visible = true;
                notifsBell.Visible = true;

                Logo.HRef = "~/About";

                LoginName ln = (LoginName)loginView.FindControl("helloUsername");
                ln.FormatString = "Hello " + user.Username + " !";
                Image image = (Image)loginView.FindControl("picture");
                image.ImageUrl = user.Picture;
                image.AlternateText = user.FirstName;


                if (user.Mode.Equals("driver"))
                {
                    offersList.Visible = true;
                    passengerMode.Visible = true;
                    incomingRequestsList.Visible = true;
                    HomeLink.HRef = "~/DriverHome";
                    GetNewReceivedRequests(user.Email);
                }

                if (user.Mode.Equals("passenger"))
                {
                    driverMode.Visible = true;
                    requestsList.Visible = true;
                    GetSentRequests(user.Email);
                }
            }

        }


        protected void Unnamed_LoggingOut(object sender, LoginCancelEventArgs e)
        {
            Context.GetOwinContext().Authentication.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
            HttpContext.Current.Session["User"] = null;
        }


        //protected void UpdatePanel1_Load(object sender, EventArgs e)
        //{
        //    Panel1.CssClass = "hiddenPanel";

        //    if (HttpContext.Current.Session["User"] != null)
        //    {
        //        UserDetails user = (UserDetails)HttpContext.Current.Session["User"];


        //        if (user.Mode.Equals("passenger"))
        //        {
        //            List<Request> sentRequests = (List<Request>)HttpContext.Current.Session["SentRequests"];
        //            List<List<object>> requests = new List<List<object>>();
        //            List<Tuple<int, string>> requestsStatusChange;

        //            foreach (var r in sentRequests)
        //            {
        //                requests.Add(new List<object>() { r.RequestId, r.Approved, r.Rejected });
        //            }
                    
        //            json = api.GetPassengerNotifications(requests);
        //            requestsStatusChange = parser.ParsePassengerNotifications(json);

        //            if (requestsStatusChange.Count > 0)
        //            {
        //                Panel1.CssClass = "alert alert-dismissible alert-warning notificationPanel";
                        
        //                foreach(var r in sentRequests)
        //                {
        //                    if(r.RequestId == requestsStatusChange[0].Item1)
        //                    {
        //                        UserDetails driver = GetUserDetails(r.Offer.UserId);
        //                        Label1.Text = "Request sent to" + driver.FirstName + " was " + requestsStatusChange[0].Item2;
        //                        Image1.ImageUrl = driver.Picture;
        //                        break;
        //                    }
        //                }
        //            }
        //        }
        //    }
            
        //}

        
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

                if (requests.Count > 0)
                {
                    newRequests.Visible = true;
                    newRequests.InnerText = requests.Count.ToString();
                }

                HttpContext.Current.Session["Requests"] = requests;
                HttpContext.Current.Session["RequestedOffers"] = offers;
            }
            catch (Exception e)
            {
                //ErrorMessage.Text = "Error retrieving your list of sent requests.";
            }

            return requests;
        }


        //public List<Request> GetApprovedRequests(string Email)
        //{

        //    PickrWebService api = new PickrWebService();
        //    JSONParser parser = new JSONParser();
        //    List<Request> requests = new List<Request>();
        //    List<Offer> offers = new List<Offer>();

        //    JObject json = api.GetPassengerSentRequests(Email);

        //    try
        //    {
        //        requests = parser.ParseRequestsList(json);
        //        List<int> offerIds = new List<int>();

        //        foreach (Request r in requests)
        //            offerIds.Add(r.OfferId);

        //        if (requests.Count > 0)
        //        {
        //            json = api.GetRequestedOffersList(offerIds);
        //            offers = parser.ParseOffersList(json);

        //            foreach (var r in requests)
        //                foreach (var o in offers)
        //                    if (r.OfferId == o.OfferId)
        //                        r.Offer = o;

        //        }

        //        if (requests.Count > 0)
        //        {
        //            approvedRequests.Visible = true;
        //            approvedRequests.InnerText = requests.Count.ToString();
        //        }

        //        HttpContext.Current.Session["Requests"] = requests;
        //    }
        //    catch (Exception e)
        //    {
        //        //ErrorMessage.Text = "Error retrieving your list of sent requests.";
        //    }

        //    return requests;
        //}


        public List<Request> GetSentRequests(string Email)
        {

            PickrWebService api = new PickrWebService();
            JSONParser parser = new JSONParser();
            List<Request> requests = new List<Request>();
            List<Offer> offers = new List<Offer>();
            int updated = 0;

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
                    {
                        if(r.Approved || r.Rejected)
                        {
                            updated++;
                        }

                        foreach (var o in offers)
                        {
                            if (r.OfferId == o.OfferId)
                            {
                                r.Offer = o;
                            }
                        }
                    }

                    if(updated>0)
                    {
                        updatedRequests.Visible = true;
                        updatedRequests.InnerText = updated.ToString();
                    }


                }


                HttpContext.Current.Session["SentRequests"] = requests;
            }
            catch (Exception e)
            {
                //ErrorMessage.Text = "Error retrieving your list of sent requests.";
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
                //ErrorMessage.Text = "Error getting user data.";
            }

            return user;
        }



    }
}