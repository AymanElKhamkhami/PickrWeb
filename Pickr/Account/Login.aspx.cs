using System;
using System.Web;
using System.Web.UI;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Owin;
using Pickr.Models;
using System.Net.Mail;
using Newtonsoft.Json.Linq;
using JSONWebService;
using System.Collections.Generic;
using System.Configuration;
using System.Net;
using System.IO;
using System.Web.Script.Serialization;
using System.Text;
using System.Data;
using System.Threading;

namespace Pickr.Account
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            RegisterHyperLink.NavigateUrl = "Register";

            // Enable this once you have account confirmation enabled for password reset functionality
            //ForgotPasswordHyperLink.NavigateUrl = "Forgot";
            OpenAuthLogin.ReturnUrl = Request.QueryString["ReturnUrl"];
            var returnUrl = HttpUtility.UrlEncode(Request.QueryString["ReturnUrl"]);

            //Register Link
            if (!String.IsNullOrEmpty(returnUrl))
            {
                RegisterHyperLink.NavigateUrl += "?ReturnUrl=" + returnUrl;
            }

            //Facebook Login
            if (!String.IsNullOrEmpty(Request.QueryString["code"]))
            {
                FacebookLogin(Request.QueryString["code"]);
            }
        }

        protected void LogIn_Click(object sender, EventArgs e)
        {
            string email = Email.Text;
            string password = Password.Text;
            //string username = new MailAddress(email).User;

            LocalLogin(email, password);

        }

        protected void Facebook_Click(object sender, EventArgs e)
        {
            //Redirect to the same actual page with Facebook API code response if it is null
            string url = ("https://www.facebook.com/v2.4/dialog/oauth/?client_id=" + ConfigurationManager.AppSettings["FacebookID"] + "&redirect_uri=http://" + Request.ServerVariables["SERVER_NAME"] + ":" + Request.ServerVariables["SERVER_PORT"] + "/Account/Login.aspx&response_type=code&state=1&scope=email,user_birthday");

            Response.Redirect(url);

        }

        public void FacebookLogin(string code)
        {
            UserDetails facebookUser = GetFacebookUserData(code);
            UserDetails user = new UserDetails();

            // Check the existance of an identical local account
            PickrWebService api = new PickrWebService();
            JObject json = api.CheckUserExistence(facebookUser.Email);
            bool exists = (bool)json["Value"];

            if (exists)
            {
                json = api.GetUser(facebookUser.Email);
                JSONParser parser = new JSONParser();
                user = parser.ParseUser(json);

                // Update profile with facebook data
                json = api.UpdateUser(user.Email, facebookUser.FirstName, facebookUser.Surname, DateTime.MinValue, "", "", facebookUser.Picture, "", "", "");
                bool updated = parser.ParseUpdateTable(json);
                //UpdateUser(user.Email, facebookUser.FirstName, facebookUser.Surname, DateTime.MinValue, "", "", facebookUser.Picture, "", "");

                LocalLogin(user.Email, user.Password);
            }

            else
            {
                HttpContext.Current.Session["FacebookUser"] = facebookUser;
                Response.Redirect("/Account/RegisterFacebook");
            }

        }
        
        protected UserDetails GetFacebookUserData(string code)
        {
            // Exchange the code for an access token
            Uri targetUri = new Uri("https://graph.facebook.com/oauth/access_token?client_id=" + ConfigurationManager.AppSettings["FacebookID"] + "&client_secret=" + ConfigurationManager.AppSettings["FacebookSecret"] + "&redirect_uri=http://" + Request.ServerVariables["SERVER_NAME"] + ":" + Request.ServerVariables["SERVER_PORT"] + "/Account/Login.aspx&code=" + code);

            HttpCookie myCookie = new HttpCookie("targetUri");
            myCookie["Uri"] = targetUri.ToString();
            myCookie.Expires = DateTime.Now.AddDays(1d);
            Response.Cookies.Add(myCookie);

            HttpWebRequest at = (HttpWebRequest)HttpWebRequest.Create(targetUri);

            System.IO.StreamReader str = new System.IO.StreamReader(at.GetResponse().GetResponseStream());
            string token = str.ReadToEnd().ToString().Replace("access_token=", "");

            // Split the access token and expiration from the single string
            string[] combined = token.Split('&');
            string accessToken = combined[0];

            // Exchange the code for an extended access token
            Uri eatTargetUri = new Uri("https://graph.facebook.com/oauth/access_token?grant_type=fb_exchange_token&client_id=" + ConfigurationManager.AppSettings["FacebookID"] + "&client_secret=" + ConfigurationManager.AppSettings["FacebookSecret"] + "&fb_exchange_token=" + accessToken);
            HttpWebRequest eat = (HttpWebRequest)HttpWebRequest.Create(eatTargetUri);

            StreamReader eatStr = new StreamReader(eat.GetResponse().GetResponseStream());
            string eatToken = eatStr.ReadToEnd().ToString().Replace("access_token=", "");

            // Split the access token and expiration from the single string
            string[] eatWords = eatToken.Split('&');
            string extendedAccessToken = eatWords[0];

            // Request the Facebook user information
            Uri targetUserUri = new Uri("https://graph.facebook.com/me?fields=name,first_name,last_name,picture.width(200).height(200),birthday,email,gender&access_token=" + accessToken);
            HttpWebRequest facebookUser = (HttpWebRequest)HttpWebRequest.Create(targetUserUri);

            // Read the returned JSON object response
            StreamReader userInfo = new StreamReader(facebookUser.GetResponse().GetResponseStream());
            string jsonResponse = string.Empty;
            jsonResponse = userInfo.ReadToEnd();

            // Parse the JSON object to a user object
            JObject json = JObject.Parse(jsonResponse);
            UserDetails user = new UserDetails();
            user.Email = (string)json["email"];
            user.Username = (string)json["first_name"];
            user.FirstName = (string)json["first_name"];
            user.Surname = (string)json["last_name"];
            user.Gender = ((string)json["gender"]).Substring(0, 1);
            user.Picture = (string)json["picture"]["data"]["url"];
            var birth = (DateTime)json["birthday"];

            if (birth != null)
                user.Birth = birth;

            return user;

        }

        public void LocalLogin(string Email, string Password)
        {
            if (!String.IsNullOrEmpty(Email) && !String.IsNullOrEmpty(Password))
            {
                PickrWebService api = new PickrWebService();
                JSONParser parser = new JSONParser();
                UserDetails user = new UserDetails();

                JObject json = api.UserAuthentication(Email, Password);

                bool valid = parser.ParseUserAuthentication(json);

                // If the user exists then give acces

                if (valid)
                {

                    json = api.GetUser(Email);
                    user = parser.ParseUser(json);

                    //if (IsValid)
                    //{
                    ApplicationUserManager manager;
                    ApplicationSignInManager signinManager;
                    SignInStatus result;

                    try
                    {
                        // Validate the user password
                        manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
                        signinManager = Context.GetOwinContext().GetUserManager<ApplicationSignInManager>();

                        // This doen't count login failures towards account lockout
                        // To enable password failures to trigger lockout, change to shouldLockout: true
                        result = signinManager.PasswordSignIn(Email, Password, RememberMe.Checked, shouldLockout: false);
                        if (result == SignInStatus.Failure)
                        {
                            //Register in the Sign in manager local database if user doesn't exist
                            var registerResult = manager.Create(new ApplicationUser() { UserName = Email, Email = Email }, Password);
                            if (registerResult.Succeeded)
                                result = signinManager.PasswordSignIn(Email, Password, RememberMe.Checked, shouldLockout: false);
                        }

                        switch (result)
                        {
                            case SignInStatus.Success:

                                Response.Cookies["SoonNotification"].Value = "0";
                                HttpContext.Current.Session["User"] = user;

                                //IdentityHelper.RedirectToReturnUrl(Request.QueryString["ReturnUrl"], Response);
                                if(user.Mode.Equals("driver")) Response.Redirect("/DriverHome");
                                else Response.Redirect("/PassengerHome");
                                break;
                            case SignInStatus.LockedOut:
                                Response.Redirect("/Account/Lockout");
                                break;
                            case SignInStatus.RequiresVerification:
                                Response.Redirect(String.Format("/Account/TwoFactorAuthenticationSignIn?ReturnUrl={0}&RememberMe={1}",
                                                                Request.QueryString["ReturnUrl"],
                                                                RememberMe.Checked),
                                                  true);
                                break;
                            case SignInStatus.Failure:
                            default:
                                FailureText.Text = "Invalid login attempt";
                                ErrorMessage.Visible = true;
                                break;
                        }

                    }
                    catch (DataException e)
                    {
                        FailureText.Text = "Error while logging in, please try again";
                        ErrorMessage.Visible = true;
                    }


                    //}
                }

                else
                {
                    FailureText.Text = "Invalid email or password";
                    ErrorMessage.Visible = true;
                }

            }
        }


        
        

        //public string UpdateUser(string Email, string FirstName, string Surname, DateTime Birth, string Gender, string Mobile, string Picture, string Address, string CarModel)
        //{
        //    string query = "UPDATE UserDetails SET ";
        //    query += !String.IsNullOrEmpty(FirstName) ? ("FirstName = '" + FirstName + "' , ") : "";
        //    query += !String.IsNullOrEmpty(Surname) ? ("Surname = '" + Surname + "' , ") : "";
        //    query += ((Birth != null) && (Birth != DateTime.MinValue)) ? ("Birth = '" + Birth + "' , ") : "";
        //    query += !String.IsNullOrEmpty(Gender) ? ("Gender = '" + Gender + "' , ") : "";
        //    query += !String.IsNullOrEmpty(Mobile) ? ("Mobile = '" + Mobile + "' , ") : "";
        //    query += !String.IsNullOrEmpty(Picture) ? ("Picture = '" + Picture + "' , ") : "";
        //    query += !String.IsNullOrEmpty(Address) ? ("Address = '" + Address + "' , ") : "";
        //    string lastColumn = !String.IsNullOrEmpty(CarModel) ? ("CarModel = '" + CarModel + "' , ") : "";

        //    if (!String.IsNullOrEmpty(lastColumn)) query += lastColumn;
        //    else query = query.Substring(0, query.Length - 2);

        //    query += " WHERE Email ='" + Email + "';";


        //    return query;
        //}




    }
}