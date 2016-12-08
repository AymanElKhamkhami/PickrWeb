using JSONWebService;
using Newtonsoft.Json.Linq;
using Pickr.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Pickr.Account
{
    public partial class Profile : Page
    {
        UserDetails u;

        protected void Page_Load(object sender, EventArgs e)
        {
            DrivingInfo.Visible = false;
            
            if(Request.QueryString["id"] != null)
            {
                Edit.Visible = false;
                int userId = Int32.Parse(Request.QueryString["id"].ToString());
                u = GetUserDetails(userId);
            }

            else u = (UserDetails) HttpContext.Current.Session["User"];

            Head.InnerText = "My name is " + u.FirstName + " " + u.Surname + ".";
            Address.InnerText = u.Address;
            Address.HRef = "http://www.google.com/#q=" +u.Address.Replace(" ", "+") + "+map";
            MemberSince.Text = "Member since " + u.MemberSince.ToString("MMMM") + " " + u.MemberSince.Year;
            FullName.Text = u.FirstName + " " + u.Surname;
            Email.Text = u.Email;
            Mobile.Text = !String.IsNullOrEmpty(u.Mobile) ? u.Mobile : "Not specified";
            Age.Text = u.CalculateAge() + " years old";
            Picture.Src = u.Picture;
            
            Mode.Text = u.Mode.Equals("driver") ? "Driver" : "Passenger";
            comment.InnerText = u.Mode.Equals("driver") ? "It was nice to meet "+u.FirstName+". Very chatty and easy going. Reached my destination at the exact planned time. Hope to ride with him again :-)" : "It was nice to meet "+u.FirstName+". Everything was at the exact planned time.";
            commentsFrom.InnerText = u.Mode.Equals("driver") ? "Comments from passengers" : "Comments from drivers";

            if ((!String.IsNullOrEmpty(u.Mobile) && u.Mode.Equals("driver")))
            {
                DrivingInfo.Visible = true;

                Car.Text = u.CarModel;
                Smoking.Text = u.Preferences.Smoking == true ? "Yes" : "No";
                Music.Text = u.Preferences.Music == true ? "Yes" : "No";
                Pets.Text = u.Preferences.Pets == true ? "Yes" : "No";

                if (u.Preferences.Talking == 1) Talking.Text = "Rarely";
                else if (u.Preferences.Talking == 2) Talking.Text = "Average";
                else if (u.Preferences.Talking == 3) Talking.Text = "Chatty";
            }
            
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
            catch (Exception e) {}

            return user;
        }
    }
}