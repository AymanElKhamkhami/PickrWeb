using JSONWebService;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
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
    public partial class RegisterFacebook : System.Web.UI.Page
    {

        public UserDetails facebookUser;

        protected void Page_Load(object sender, EventArgs e)
        {
            BirthLabel.Visible = false;
            BirthFacebook.Visible = false;
            //BirthFacebook.CausesValidation = false;
            BirthValidator.Enabled = false;

            if (HttpContext.Current.Session["FacebookUser"] != null && !HttpContext.Current.Session["FacebookUser"].Equals(""))
            {
                facebookUser = (UserDetails)HttpContext.Current.Session["FacebookUser"];
                ExternalUsername.Text = "'" + facebookUser.Username + " " + facebookUser.Surname + "'";
                
                // If the birth date is not set
                if (facebookUser.Birth == DateTime.MinValue)
                {
                    BirthLabel.Visible = true;
                    BirthFacebook.Visible = true;
                    //BirthFacebook.CausesValidation = true;
                    BirthValidator.Enabled = true;
                }
                
            }
        }

        protected void Register_Click(object sender, EventArgs e)
        {
            HttpContext.Current.Session["FacebookUser"] = null;

            if (facebookUser != null)
            {
                DateTime birth = new DateTime();

                if (BirthLabel.Visible == true)
                {
                    birth = Convert.ToDateTime(BirthFacebook.Text);
                    facebookUser.Birth = birth;
                }

                facebookUser.Address = Address.Text;

                string randomPassword = System.Web.Security.Membership.GeneratePassword(6, 1)+"A1";
                RegisterUser(facebookUser.Email, facebookUser.Username, randomPassword, facebookUser.FirstName, facebookUser.Surname, facebookUser.Birth, facebookUser.Gender, "", facebookUser.Picture, facebookUser.Address);
            }
        }


        public void RegisterUser(string email, string username, string password, string firstname, string surname, DateTime birth, string gender, string mobile, string picture, string address)
        {
            PickrWebService api = new PickrWebService();
            JSONParser parser = new JSONParser();
            UserDetails u = new UserDetails();

            JObject json = api.CreateUser(email, username, password, firstname, surname, birth, gender, mobile, picture, address);

            //bool valid = parser.ParseCreateNewUser(json);

            var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
            var signInManager = Context.GetOwinContext().Get<ApplicationSignInManager>();
            var user = new ApplicationUser() { UserName = email, Email = email };
            IdentityResult result = manager.Create(user, password);
            var b = result.Succeeded;

            if (b)
            {
                bool added = false;
                added = parser.ParseCreateTable(json);

                if (added)
                {
                    
                    u.Email = email;
                    u.Password = password;
                    u.Username = username;
                    u.FirstName = firstname;
                    u.Surname = surname;
                    u.Birth = birth;
                    u.Gender = gender;
                    u.Picture = picture;
                    u.Address = address;
                    u.MemberSince = DateTime.Now;
                    HttpContext.Current.Session["User"] = u;

                    signInManager.SignIn(user, isPersistent: false, rememberBrowser: false);
                    //IdentityHelper.RedirectToReturnUrl(Request.QueryString["ReturnUrl"], Response);
                    Response.Redirect("~/Default");

                }

                else if (!added)
                {
                    ErrorMessage.Text = "A user already exists with the same Username or Email you provided.";
                    manager.Delete(user);
                }
            }

            else
            {
                ErrorMessage.Text = result.Errors.FirstOrDefault();
            }
        }
    }
}