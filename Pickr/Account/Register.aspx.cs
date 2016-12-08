using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Owin;
using Pickr.Models;
using System.Diagnostics;
using JSONWebService;
using Newtonsoft.Json.Linq;

namespace Pickr.Account
{
    public partial class Register : Page
    {
        protected void CreateUser_Click(object sender, EventArgs e)
        {
            string email = Email.Text;
            string password = Password.Text;
            string username = Username.Text;
            string firstname = FirstName.Text;
            string surname = Surname.Text;
            DateTime birth = Convert.ToDateTime(Birth.Text);
            string gender = Gender.Text;
            string mobile = Mobile.Text;
            string address = Address.Text;
            //string username = new MailAddress(email).User;

            if (!String.IsNullOrEmpty(email) && !String.IsNullOrEmpty(password))
            {
                RegisterUser(email, username, password, firstname, surname, birth, gender, mobile, address);
            }

            else
            {
                Debug.Fail("ERROR : We should never log in without a user email and a password.");
                throw new Exception("ERROR : It is illegal to load  the user page without setting a user email and a password.");
            }
            
        }


        public void RegisterUser(string email, string username, string password, string firstname, string surname, DateTime birth, string gender, string mobile, string address)
        {
            PickrWebService api = new PickrWebService();
            JSONParser parser = new JSONParser();
            UserDetails u = new UserDetails();

            DateTime membersince = DateTime.Now;
            string picture = "http://www.pickrwebservice.somee.com/images/profile/default-" + gender + ".jpg";

            

            //bool valid = parser.ParseCreateNewUser(json);

            //Create in localDB
            var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
            var signInManager = Context.GetOwinContext().Get<ApplicationSignInManager>();
            var user = new ApplicationUser() { UserName = email, Email = email };
            IdentityResult result = manager.Create(user, password);
            var b = result.Succeeded;
            //End create in localDB


            if (b)
            {
                bool added = false;

                JObject json = api.CreateUser(email, username, password, firstname, surname, birth, gender, mobile, picture, address);
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
                    u.MemberSince = membersince;
                    u.Mobile = mobile;
                    u.Picture = picture;
                    u.Address = address;

                    HttpContext.Current.Session["User"] = u;

                    //Signin localDB
                    signInManager.SignIn(user, isPersistent: false, rememberBrowser: false);
                    //IdentityHelper.RedirectToReturnUrl(Request.QueryString["ReturnUrl"], Response);
                    //End signin localDB
                    Response.Redirect("/PassengerHome");

                }

                else if (!added)
                {
                    ErrorMessage.Text = "The Username or Email you provided are already taken by another user.";
                    //Delete from localDB
                    manager.Delete(user);
                    //End delete from localDB
                }
            }
            


            else
            {
                ErrorMessage.Text = result.Errors.FirstOrDefault();
            }
        }
    }
}