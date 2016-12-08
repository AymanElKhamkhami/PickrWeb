using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using Owin;
using Pickr.Models;
using Newtonsoft.Json.Linq;
using JSONWebService;
using System.Web.UI;

namespace Pickr.Account
{
    public partial class Manage : Page
    {


        protected void Page_Load(object sender, EventArgs e)
        {
            UserDetails user = (UserDetails)HttpContext.Current.Session["User"];

            string mode = Request.QueryString["mode"];

            //Updating the user mode after the hyperlink click on the master banner
            if (!String.IsNullOrEmpty(mode) && mode.Equals("driver"))
            {
                bool updated = UpdateProfile("", "", user.Birth, "", "", "", "", "driver", "", null,null, null, null);
                if(updated) user.Mode = "driver";
            }

            else if (!String.IsNullOrEmpty(mode) && mode.Equals("passenger"))
            {
                bool updated = UpdateProfile("", "", user.Birth, "", "", "", "", "passenger", "", null, null, null, null);
                if (updated) user.Mode = "passenger";
            }
            //

            if (user.Mode.Equals("driver"))
            {
                DriverFields.Visible = true;
            }
            else
            {
                DriverFields.Visible = false;
            }

            //If the page is not loaded for the first time
            if (IsPostBack)
            {
                Control control = null;
                string ctrlname = Request.Form["__EVENTTARGET"];
                if (ctrlname != null && ctrlname != String.Empty)
                {
                    control = Page.FindControl(ctrlname);

                    if (control.ID == "Update")
                    {
                        //Show success notification
                        //ClientScript.RegisterStartupScript(this.GetType(), "blah", "showNotification();", true);
                        //ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "tmp", "<script type='text/javascript'>showNotification();</script>", false);
                        //isUpdateMade.Value = "Yes";

                        string firstname = FirstName.Text;
                        string surname = Surname.Text;
                        DateTime birth = Convert.ToDateTime(Birth.Text);
                        string gender = Gender.SelectedValue;
                        string mobile = Mobile.Text;
                        string address = Address.SelectedValue;
                        string picture = "";
                        string car = Car.Text;
                        bool? smoking = null;
                        bool? music = null;
                        bool? pets = null;
                        int? talking = null;

                        if(user.Mode.Equals("driver"))
                        {
                            smoking = Smoking.SelectedIndex == 0 ? true : false;
                            music = Music.SelectedIndex == 0 ? true : false;
                            pets = Pets.SelectedIndex == 0 ? true : false;
                            if (Talking.SelectedIndex == 0) talking = 1;
                            else if (Talking.SelectedIndex == 1) talking = 2;
                            else if (Talking.SelectedIndex == 2) talking = 3;
                        }

                        UpdateProfile(firstname, surname, birth, gender, mobile, picture, address, "", car, smoking, music, pets, talking);

                    }
                }
            }

            //Default page load
            else
            {
                LoadProfile(user);
            }

        }


        protected void SaveUpdates_Click(object sender, EventArgs e)
        {
        }

        public bool UpdateProfile(string firstname, string surname, DateTime birth, string gender, string mobile, string picture, string address, string mode, string car, bool? smoking, bool? music, bool? pets, int? talking)
        {
            PickrWebService api = new PickrWebService();
            JSONParser parser = new JSONParser();
            UserDetails u = (UserDetails)HttpContext.Current.Session["User"];

            JObject json = api.UpdateUser(u.Email, firstname, surname, birth, gender, mobile, picture, address, mode, car);

            
            bool updated = false;
            updated = parser.ParseUpdateTable(json);


            if (smoking!=null && music !=null && pets != null && talking != null)
            {
                JObject jsonPrefs = api.SetUserPreferences(u.Email, (bool)smoking, (bool)music, (bool)pets, (int)talking);
                bool prefsUpdated = false;
                prefsUpdated = parser.ParseUpdateTable(jsonPrefs);
                updated = updated && prefsUpdated;
            }
                


            if (updated)
            {

                json = api.GetUser(u.Email);
                u = parser.ParseUser(json);

                // Update session user
                HttpContext.Current.Session["User"] = u;
                Response.Redirect("Manage?updated=true");
            }

            else if (!updated)
            {
                ErrorMessage.Text = "Profile could not be updated.";
            }

            return updated;
        }

        

        public void LoadProfile(UserDetails user)
        {
            FirstName.Text = user.FirstName;
            Surname.Text = user.Surname;
            Birth.Text = user.Birth.ToString("yyyy-MM-dd");
            Gender.SelectedValue = user.Gender;
            Mobile.Text = user.Mobile;

            if (user.Address.StartsWith("S") || user.Address.ElementAt(0).Equals("Ś")) Address.SelectedIndex = 0;
            else if (user.Address.StartsWith("W")) Address.SelectedIndex = 1;
            else if (user.Address.StartsWith("P")) Address.SelectedIndex = 2;
            else if (user.Address.StartsWith("B")) Address.SelectedIndex = 3;
            else if (user.Address.StartsWith("G")) Address.SelectedIndex = 4;

            if (DriverFields.Visible)
                Car.Text = user.CarModel;

            if(user.Preferences != null)
            {
                if (user.Preferences.Smoking) Smoking.SelectedIndex = 0;
                else Smoking.SelectedIndex = 1;

                if (user.Preferences.Music) Music.SelectedIndex = 0;
                else Music.SelectedIndex = 1;

                if (user.Preferences.Pets) Pets.SelectedIndex = 0;
                else Pets.SelectedIndex = 1;

                if (user.Preferences.Talking == 1) Talking.SelectedIndex = 0;
                else if (user.Preferences.Talking == 2) Talking.SelectedIndex = 1;
                else if (user.Preferences.Talking == 3) Talking.SelectedIndex = 2;
            }
            
        }


    }
}