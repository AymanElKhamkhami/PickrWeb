/* Pickr JSON Web Service */
using System;
using System.Linq;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.IO;
using System.Collections;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;

namespace JSONWebService  {
    public class PickrWebService {
        //private const string urlString = "http://www.dmcsrestful.somee.com/Handler.ashx";
        //private const string urlString = "http://localhost:8080/Handler.ashx";
        private const string urlString = "http://pickrwebservice.somee.com/Handler.ashx";
        private const int bufferSize = 4096;

        private string Load(string contents)
       {
            HttpWebRequest req = (HttpWebRequest)WebRequest.Create(urlString);
            req.AllowWriteStreamBuffering = true;
            req.Method = "POST";
            req.Timeout = 100000;
            Stream outStream = req.GetRequestStream();
            StreamWriter outStreamWriter = new StreamWriter(outStream);
            outStreamWriter.Write(contents);

            outStreamWriter.Flush();
            outStream.Close();
            try
            {
                WebResponse res = req.GetResponse();
                Stream httpStream = res.GetResponseStream();
                MemoryStream memoryStream = new MemoryStream();
                try
                {
                    byte[] buff = new byte[bufferSize];
                    int readedBytes = httpStream.Read(buff, 0, buff.Length);
                    while (readedBytes > 0)
                    {
                        memoryStream.Write(buff, 0, readedBytes);
                        readedBytes = httpStream.Read(buff, 0, buff.Length);
                    }
                }
                finally
                {
                    if (httpStream != null)
                    {
                        httpStream.Close();
                    }

                    if (memoryStream != null)
                    {
                        memoryStream.Close();
                    }
                }
                byte[] data = memoryStream.ToArray();
                string result = Encoding.UTF8.GetString(data, 0, data.Length);
                return result;

            } catch(WebException e)
            {
                return "timout";
            }
            
            
        }


        //public JObject CreateUser(string Email, string Username, string Password, string FirstName, string Surname, DateTime Birth, string Gender, string Mobile, string Picture, string Address) {
        //    JObject result = null;
        //    JObject o = new JObject();
        //    JObject p = new JObject();
        //    o["interface"] = "PickrWebService";
        //    o["method"]= "CreateUser";
        //    p["Email"]= JToken.FromObject(Email);
        //    p["Username"]= JToken.FromObject(Username);
        //    p["Password"]= JToken.FromObject(Password);
        //    p["FirstName"]= JToken.FromObject(FirstName);
        //    p["Surname"]= JToken.FromObject(Surname);
        //    p["Birth"]= JToken.FromObject(Birth);
        //    p["Gender"]= JToken.FromObject(Gender);
        //    p["Mobile"]= JToken.FromObject(Mobile);
        //    p["Picture"]= JToken.FromObject(Picture);
        //    p["Address"]= JToken.FromObject(Address);
        //    o["parameters"] = p;
        //    string s = JsonConvert.SerializeObject(o);
        //    string r = Load(s);
        //    result = JObject.Parse(SomeeAdRemover(r));
        //    return result;
        //}

        //public JObject CheckUserExistence(string Email) {
        //    JObject result = null;
        //    JObject o = new JObject();
        //    JObject p = new JObject();
        //    o["interface"] = "PickrWebService";
        //    o["method"]= "CheckUserExistence";
        //    p["Email"]= JToken.FromObject(Email);
        //    o["parameters"] = p;
        //    string s = JsonConvert.SerializeObject(o);
        //    string r = Load(s);
        //    result = JObject.Parse(SomeeAdRemover(r));
        //    return result;
        //}

        //public JObject UserAuthentication(string Email,string Password) {
        //    JObject result = null;
        //    JObject o = new JObject();
        //    JObject p = new JObject();
        //    o["interface"] = "PickrWebService";
        //    o["method"]= "UserAuthentication";
        //    p["Email"]= JToken.FromObject(Email);
        //    p["Password"]= JToken.FromObject(Password);
        //    o["parameters"] = p;
        //    string s = JsonConvert.SerializeObject(o);
        //    string r = Load(s);
        //    result = JObject.Parse(SomeeAdRemover(r));
        //    return result;
        //}

        //public JObject GetUser(string Email) {
        //    JObject result = null;
        //    JObject o = new JObject();
        //    JObject p = new JObject();
        //    o["interface"] = "PickrWebService";
        //    o["method"]= "GetUser";
        //    p["Email"]= JToken.FromObject(Email);
        //    o["parameters"] = p;
        //    string s = JsonConvert.SerializeObject(o);
        //    string r = Load(s);
        //    result = JObject.Parse(SomeeAdRemover(r));
        //    return result;
        //}

        //public JObject UpdateUser(string Email,string FirstName,string Surname,DateTime Birth,string Gender,string Mobile,string Picture,string Address,string Mode,string CarModel) {
        //    JObject result = null;
        //    JObject o = new JObject();
        //    JObject p = new JObject();
        //    o["interface"] = "PickrWebService";
        //    o["method"]= "UpdateUser";
        //    p["Email"]= JToken.FromObject(Email);
        //    p["FirstName"]= JToken.FromObject(FirstName);
        //    p["Surname"]= JToken.FromObject(Surname);
        //    p["Birth"]= JToken.FromObject(Birth);
        //    p["Gender"]= JToken.FromObject(Gender);
        //    p["Mobile"]= JToken.FromObject(Mobile);
        //    p["Picture"]= JToken.FromObject(Picture);
        //    p["Address"]= JToken.FromObject(Address);
        //    p["Mode"]= JToken.FromObject(Mode);
        //    p["CarModel"]= JToken.FromObject(CarModel);
        //    o["parameters"] = p;
        //    string s = JsonConvert.SerializeObject(o);
        //    string r = Load(s);
        //    result = JObject.Parse(SomeeAdRemover(r));
        //    return result;
        //}

        //public JObject SetUserPreferences(string Email, bool Smoking, bool Music, bool Pets, int Talking)
        //{
        //    JObject result = null;
        //    JObject o = new JObject();
        //    JObject p = new JObject();
        //    o["interface"] = "PickrWebService";
        //    o["method"] = "SetUserPreferences";
        //    p["Email"] = JToken.FromObject(Email);
        //    p["Smoking"] = JToken.FromObject(Smoking);
        //    p["Music"] = JToken.FromObject(Music);
        //    p["Pets"] = JToken.FromObject(Pets);
        //    p["Talking"] = JToken.FromObject(Talking);
        //    o["parameters"] = p;
        //    string s = JsonConvert.SerializeObject(o);
        //    string r = Load(s);
        //    result = JObject.Parse(SomeeAdRemover(r));
        //    return result;
        //}

        //public JObject CreatePreferences(bool Smoking, bool Music, bool Pets, int Talking)
        //{
        //    JObject result = null;
        //    JObject o = new JObject();
        //    JObject p = new JObject();
        //    o["interface"] = "PickrWebService";
        //    o["method"] = "CreatePreferences";
        //    p["Smoking"] = JToken.FromObject(Smoking);
        //    p["Music"] = JToken.FromObject(Music);
        //    p["Pets"] = JToken.FromObject(Pets);
        //    p["Talking"] = JToken.FromObject(Talking);
        //    o["parameters"] = p;
        //    string s = JsonConvert.SerializeObject(o);
        //    string r = Load(s);
        //    result = JObject.Parse(SomeeAdRemover(r));
        //    return result;
        //}

        //public JObject UpdatePreferences(int idPreferences, bool Smoking, bool Music, bool Pets, int Talking)
        //{
        //    JObject result = null;
        //    JObject o = new JObject();
        //    JObject p = new JObject();
        //    o["interface"] = "PickrWebService";
        //    o["method"] = "UpdatePreferences";
        //    p["idPreferences"] = JToken.FromObject(idPreferences);
        //    p["Smoking"] = JToken.FromObject(Smoking);
        //    p["Music"] = JToken.FromObject(Music);
        //    p["Pets"] = JToken.FromObject(Pets);
        //    p["Talking"] = JToken.FromObject(Talking);
        //    o["parameters"] = p;
        //    string s = JsonConvert.SerializeObject(o);
        //    string r = Load(s);
        //    result = JObject.Parse(SomeeAdRemover(r));
        //    return result;
        //}

        //public JObject CreateOffer(string Email, double StartLat, double StartLng, double DestinationLat, double DestinationLng, List<List<double>> Waypoints, List<List<double>> RangePolygon, DateTime Departure, object Arrival, int Seats, double Price, int Radius, double Distance, bool Active)
        //{
        //    JObject result = null;
        //    JObject o = new JObject();
        //    JObject p = new JObject();
        //    o["interface"] = "PickrWebService";
        //    o["method"] = "CreateOffer";
        //    p["Email"] = JToken.FromObject(Email);
        //    p["StartLat"] = JToken.FromObject(StartLat);
        //    p["StartLng"] = JToken.FromObject(StartLng);
        //    p["DestinationLat"] = JToken.FromObject(DestinationLat);
        //    p["DestinationLng"] = JToken.FromObject(DestinationLng);
        //    p["Waypoints"] = JToken.FromObject(Waypoints);
        //    p["RangePolygon"] = JToken.FromObject(RangePolygon);
        //    p["Departure"] = JToken.FromObject(Departure);
        //    p["Arrival"] = JToken.FromObject(Arrival);
        //    p["Seats"] = JToken.FromObject(Seats);
        //    p["Price"] = JToken.FromObject(Price);
        //    p["Radius"] = JToken.FromObject(Radius);
        //    p["Distance"] = JToken.FromObject(Distance);
        //    p["Active"] = JToken.FromObject(Active);
        //    o["parameters"] = p;
        //    string s = JsonConvert.SerializeObject(o);
        //    string r = Load(s);
        //    result = JObject.Parse(SomeeAdRemover(r));
        //    return result;
        //}

        //public JObject GetOffersList(string Email)
        //{
        //    JObject result = null;
        //    JObject o = new JObject();
        //    JObject p = new JObject();
        //    o["interface"] = "PickrWebService";
        //    o["method"] = "GetOffersList";
        //    p["Email"] = JToken.FromObject(Email);
        //    o["parameters"] = p;
        //    string s = JsonConvert.SerializeObject(o);
        //    string r = Load(s);
        //    result = JObject.Parse(SomeeAdRemover(r));
        //    return result;
        //}

        //public JObject UpdateOffer(int IdOffer, object StartLat, object StartLng, object DestinationLat, object DestinationLng, List<List<double>> Waypoints, List<List<double>> RangePolygon, object Departure, object Arrival, object Seats, object ReservedSeats, object Price, object Radius, object Distance, object Active)
        //{
        //    JObject result = null;
        //    JObject o = new JObject();
        //    JObject p = new JObject();
        //    o["interface"] = "PickrWebService";
        //    o["method"] = "UpdateOffer";
        //    p["IdOffer"] = JToken.FromObject(IdOffer);
        //    p["StartLat"] = JToken.FromObject(StartLat);
        //    p["StartLng"] = JToken.FromObject(StartLng);
        //    p["DestinationLat"] = JToken.FromObject(DestinationLat);
        //    p["DestinationLng"] = JToken.FromObject(DestinationLng);
        //    p["Waypoints"] = JToken.FromObject(Waypoints);
        //    p["RangePolygon"] = JToken.FromObject(RangePolygon);
        //    p["Departure"] = JToken.FromObject(Departure);
        //    p["Arrival"] = JToken.FromObject(Arrival);
        //    p["Seats"] = JToken.FromObject(Seats);
        //    p["ReservedSeats"] = JToken.FromObject(ReservedSeats);
        //    p["Price"] = JToken.FromObject(Price);
        //    p["Radius"] = JToken.FromObject(Radius);
        //    p["Distance"] = JToken.FromObject(Distance);
        //    p["Active"] = JToken.FromObject(Active);
        //    o["parameters"] = p;
        //    string s = JsonConvert.SerializeObject(o);
        //    string r = Load(s);
        //    result = JObject.Parse(SomeeAdRemover(r));
        //    return result;
        //}

        //public JObject CreateWaypointsList(int IdOffer, List<List<double>> Waypoints)
        //{
        //    JObject result = null;
        //    JObject o = new JObject();
        //    JObject p = new JObject();
        //    o["interface"] = "PickrWebService";
        //    o["method"] = "CreateWaypointsList";
        //    p["IdOffer"] = JToken.FromObject(IdOffer);
        //    p["Waypoints"] = JToken.FromObject(Waypoints);
        //    o["parameters"] = p;
        //    string s = JsonConvert.SerializeObject(o);
        //    string r = Load(s);
        //    result = JObject.Parse(SomeeAdRemover(r));
        //    return result;
        //}

        //public JObject CreatePolygon(int IdOffer, List<List<double>> RangePolygon)
        //{
        //    JObject result = null;
        //    JObject o = new JObject();
        //    JObject p = new JObject();
        //    o["interface"] = "PickrWebService";
        //    o["method"] = "CreatePolygon";
        //    p["IdOffer"] = JToken.FromObject(IdOffer);
        //    p["RangePolygon"] = JToken.FromObject(RangePolygon);
        //    o["parameters"] = p;
        //    string s = JsonConvert.SerializeObject(o);
        //    string r = Load(s);
        //    result = JObject.Parse(SomeeAdRemover(r));
        //    return result;
        //}

        //public JObject GetWaypointsList(int IdOffer)
        //{
        //    JObject result = null;
        //    JObject o = new JObject();
        //    JObject p = new JObject();
        //    o["interface"] = "PickrWebService";
        //    o["method"] = "GetWaypointsList";
        //    p["IdOffer"] = JToken.FromObject(IdOffer);
        //    o["parameters"] = p;
        //    string s = JsonConvert.SerializeObject(o);
        //    string r = Load(s);
        //    result = JObject.Parse(SomeeAdRemover(r));
        //    return result;
        //}

        //public JObject GetRangeIndices(int IdOffer)
        //{
        //    JObject result = null;
        //    JObject o = new JObject();
        //    JObject p = new JObject();
        //    o["interface"] = "PickrWebService";
        //    o["method"] = "GetRangeIndices";
        //    p["IdOffer"] = JToken.FromObject(IdOffer);
        //    o["parameters"] = p;
        //    string s = JsonConvert.SerializeObject(o);
        //    string r = Load(s);
        //    result = JObject.Parse(SomeeAdRemover(r));
        //    return result;
        //}

        //public JObject DeleteWaypointsList(int IdOffer)
        //{
        //    JObject result = null;
        //    JObject o = new JObject();
        //    JObject p = new JObject();
        //    o["interface"] = "PickrWebService";
        //    o["method"] = "DeleteWaypointsList";
        //    p["IdOffer"] = JToken.FromObject(IdOffer);
        //    o["parameters"] = p;
        //    string s = JsonConvert.SerializeObject(o);
        //    string r = Load(s);
        //    result = JObject.Parse(SomeeAdRemover(r));
        //    return result;
        //}

        //public JObject DeletePolygon(int IdOffer)
        //{
        //    JObject result = null;
        //    JObject o = new JObject();
        //    JObject p = new JObject();
        //    o["interface"] = "PickrWebService";
        //    o["method"] = "DeletePolygon";
        //    p["IdOffer"] = JToken.FromObject(IdOffer);
        //    o["parameters"] = p;
        //    string s = JsonConvert.SerializeObject(o);
        //    string r = Load(s);
        //    result = JObject.Parse(SomeeAdRemover(r));
        //    return result;
        //}


        public string SomeeAdRemover(string str)
        {
            string output = "";
            int i = str.Contains("<") ? str.IndexOf("<") : 0;
            output = i > 0 ? str.Substring(0, i) : str;
            return output;
        }



        //FOR LOCAL WEBSERVICE TESTING

        public JObject CreateUser(string Email, string Username, string Password, string FirstName, string Surname, DateTime Birth, string Gender, string Mobile, string Picture, string Address)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "CreateUser";
            p["Email"] = JToken.FromObject(Email);
            p["Username"] = JToken.FromObject(Username);
            p["Password"] = JToken.FromObject(Password);
            p["FirstName"] = JToken.FromObject(FirstName);
            p["Surname"] = JToken.FromObject(Surname);
            p["Birth"] = JToken.FromObject(Birth);
            p["Gender"] = JToken.FromObject(Gender);
            p["Mobile"] = JToken.FromObject(Mobile);
            p["Picture"] = JToken.FromObject(Picture);
            p["Address"] = JToken.FromObject(Address);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject CheckUserExistence(string Email)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "CheckUserExistence";
            p["Email"] = JToken.FromObject(Email);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject UserAuthentication(string Email, string Password)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "UserAuthentication";
            p["Email"] = JToken.FromObject(Email);
            p["Password"] = JToken.FromObject(Password);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject GetUser(string Email)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "GetUser";
            p["Email"] = JToken.FromObject(Email);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject GetUserPublic(int IdUser)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "GetUserPublic";
            p["IdUser"] = JToken.FromObject(IdUser);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject UpdateUser(string Email, string FirstName, string Surname, DateTime Birth, string Gender, string Mobile, string Picture, string Address, string Mode, string CarModel)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "UpdateUser";
            p["Email"] = JToken.FromObject(Email);
            p["FirstName"] = JToken.FromObject(FirstName);
            p["Surname"] = JToken.FromObject(Surname);
            p["Birth"] = JToken.FromObject(Birth);
            p["Gender"] = JToken.FromObject(Gender);
            p["Mobile"] = JToken.FromObject(Mobile);
            p["Picture"] = JToken.FromObject(Picture);
            p["Address"] = JToken.FromObject(Address);
            p["Mode"] = JToken.FromObject(Mode);
            p["CarModel"] = JToken.FromObject(CarModel);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject SetUserPreferences(string Email, bool Smoking, bool Music, bool Pets, int Talking)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "SetUserPreferences";
            p["Email"] = JToken.FromObject(Email);
            p["Smoking"] = JToken.FromObject(Smoking);
            p["Music"] = JToken.FromObject(Music);
            p["Pets"] = JToken.FromObject(Pets);
            p["Talking"] = JToken.FromObject(Talking);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject CreatePreferences(bool Smoking, bool Music, bool Pets, int Talking)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "CreatePreferences";
            p["Smoking"] = JToken.FromObject(Smoking);
            p["Music"] = JToken.FromObject(Music);
            p["Pets"] = JToken.FromObject(Pets);
            p["Talking"] = JToken.FromObject(Talking);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject UpdatePreferences(int idPreferences, bool Smoking, bool Music, bool Pets, int Talking)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "UpdatePreferences";
            p["idPreferences"] = JToken.FromObject(idPreferences);
            p["Smoking"] = JToken.FromObject(Smoking);
            p["Music"] = JToken.FromObject(Music);
            p["Pets"] = JToken.FromObject(Pets);
            p["Talking"] = JToken.FromObject(Talking);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject CreateOffer(string Email, double StartLat, double StartLng, double DestinationLat, double DestinationLng, List<List<double>> Waypoints, List<List<double>> RoutePoints, List<List<double>> RangePolygon, DateTime Departure, object Arrival, int Seats, double Price, int Radius, double Distance, bool Active)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "CreateOffer";
            p["Email"] = JToken.FromObject(Email);
            p["StartLat"] = JToken.FromObject(StartLat);
            p["StartLng"] = JToken.FromObject(StartLng);
            p["DestinationLat"] = JToken.FromObject(DestinationLat);
            p["DestinationLng"] = JToken.FromObject(DestinationLng);
            p["Waypoints"] = JToken.FromObject(Waypoints);
            p["RoutePoints"] = JToken.FromObject(RoutePoints);
            p["RangePolygon"] = JToken.FromObject(RangePolygon);
            p["Departure"] = JToken.FromObject(Departure);
            p["Arrival"] = JToken.FromObject(Arrival);
            p["Seats"] = JToken.FromObject(Seats);
            p["Price"] = JToken.FromObject(Price);
            p["Radius"] = JToken.FromObject(Radius);
            p["Distance"] = JToken.FromObject(Distance);
            p["Active"] = JToken.FromObject(Active);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject GetOffersList(string Email)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "GetOffersList";
            p["Email"] = JToken.FromObject(Email);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject GetRequestedOffersList(List<int> OfferIds)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "GetRequestedOffersList";
            p["OfferIds"] = JToken.FromObject(OfferIds);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject UpdateOffer(int IdOffer, object StartLat, object StartLng, object DestinationLat, object DestinationLng, List<List<double>> Waypoints, List<List<double>> RoutePoints, List<List<double>> RangePolygon, object Departure, object Arrival, object Seats, object ReservedSeats, object Price, object Radius, object Distance, object Active)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "UpdateOffer";
            p["IdOffer"] = JToken.FromObject(IdOffer);
            p["StartLat"] = JToken.FromObject(StartLat);
            p["StartLng"] = JToken.FromObject(StartLng);
            p["DestinationLat"] = JToken.FromObject(DestinationLat);
            p["DestinationLng"] = JToken.FromObject(DestinationLng);
            p["Waypoints"] = JToken.FromObject(Waypoints);
            p["RoutePoints"] = JToken.FromObject(RoutePoints);
            p["RangePolygon"] = JToken.FromObject(RangePolygon);
            p["Departure"] = JToken.FromObject(Departure);
            p["Arrival"] = JToken.FromObject(Arrival);
            p["Seats"] = JToken.FromObject(Seats);
            p["ReservedSeats"] = JToken.FromObject(ReservedSeats);
            p["Price"] = JToken.FromObject(Price);
            p["Radius"] = JToken.FromObject(Radius);
            p["Distance"] = JToken.FromObject(Distance);
            p["Active"] = JToken.FromObject(Active);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject DeleteOffer(int IdOffer)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "DeleteOffer";
            p["IdOffer"] = JToken.FromObject(IdOffer);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject CreateWaypointsList(int IdOffer, List<List<double>> Waypoints)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "CreateWaypointsList";
            p["IdOffer"] = JToken.FromObject(IdOffer);
            p["Waypoints"] = JToken.FromObject(Waypoints);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject CreateRoutePointsList(int IdOffer, List<List<double>> RoutePoints)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "CreateRoutePointsList";
            p["IdOffer"] = JToken.FromObject(IdOffer);
            p["RoutePoints"] = JToken.FromObject(RoutePoints);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject CreatePolygon(int IdOffer, List<List<double>> RangePolygon)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "CreatePolygon";
            p["IdOffer"] = JToken.FromObject(IdOffer);
            p["RangePolygon"] = JToken.FromObject(RangePolygon);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject GetWaypointsList(int IdOffer)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "GetWaypointsList";
            p["IdOffer"] = JToken.FromObject(IdOffer);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject GetRoutePointsList(int IdOffer)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "GetRoutePointsList";
            p["IdOffer"] = JToken.FromObject(IdOffer);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject GetRangeIndices(int IdOffer)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "GetRangeIndices";
            p["IdOffer"] = JToken.FromObject(IdOffer);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject DeleteWaypointsList(int IdOffer)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "DeleteWaypointsList";
            p["IdOffer"] = JToken.FromObject(IdOffer);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject DeleteRoutePointsList(int IdOffer)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "DeleteRoutePointsList";
            p["IdOffer"] = JToken.FromObject(IdOffer);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject DeletePolygon(int IdOffer)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "DeletePolygon";
            p["IdOffer"] = JToken.FromObject(IdOffer);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject SearchRides(DateTime ArrivalFrom, object ArrivalTo, double StartLat, double StartLng, double DestinationLat, double DestinationLng)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "SearchRides";
            p["ArrivalFrom"] = JToken.FromObject(ArrivalFrom);
            p["ArrivalTo"] = JToken.FromObject(ArrivalTo);
            p["StartLat"] = JToken.FromObject(StartLat);
            p["StartLng"] = JToken.FromObject(StartLng);
            p["DestinationLat"] = JToken.FromObject(DestinationLat);
            p["DestinationLng"] = JToken.FromObject(DestinationLng);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject CreateRequest(string Email, object IdOffer, double StartLat, double StartLng, double DestinationLat, double DestinationLng, DateTime ArrivalFrom, object ArrivalTo, int Seats)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "CreateRequest";
            p["Email"] = JToken.FromObject(Email);
            p["IdOffer"] = JToken.FromObject(IdOffer);
            p["StartLat"] = JToken.FromObject(StartLat);
            p["StartLng"] = JToken.FromObject(StartLng);
            p["DestinationLat"] = JToken.FromObject(DestinationLat);
            p["DestinationLng"] = JToken.FromObject(DestinationLng);
            p["ArrivalFrom"] = JToken.FromObject(ArrivalFrom);
            p["ArrivalTo"] = JToken.FromObject(ArrivalTo);
            p["Seats"] = JToken.FromObject(Seats);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject GetDriverReceivedRequests(string Email, bool Approved, bool Rejected)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "GetDriverReceivedRequests";
            p["Email"] = JToken.FromObject(Email);
            p["Approved"] = JToken.FromObject(Approved);
            p["Rejected"] = JToken.FromObject(Rejected);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject GetPassengerSentRequests(string Email)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "GetPassengerSentRequests";
            p["Email"] = JToken.FromObject(Email);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject RespondToRequest(int IdRequest, object PickUp, bool Approved)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "RespondToRequest";
            p["IdRequest"] = JToken.FromObject(IdRequest);
            p["PickUp"] = JToken.FromObject(PickUp);
            p["Approved"] = JToken.FromObject(Approved);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }
        
        public JObject CheckRequestExistence(string Email, int IdOffer)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "CheckRequestExistence";
            p["Email"] = JToken.FromObject(Email);
            p["IdOffer"] = JToken.FromObject(IdOffer);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }
        
        public JObject CheckRequestPending(string Email, int IdOffer)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "CheckRequestPending";
            p["Email"] = JToken.FromObject(Email);
            p["IdOffer"] = JToken.FromObject(IdOffer);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }

        public JObject GetPassengerNotifications(List<List<object>> Requests)
        {
            JObject result = null;
            JObject o = new JObject();
            JObject p = new JObject();
            o["interface"] = "PickrWebService";
            o["method"] = "GetPassengerNotifications";
            p["Requests"] = JToken.FromObject(Requests);
            o["parameters"] = p;
            string s = JsonConvert.SerializeObject(o);
            string r = Load(s);
            //result = JObject.Parse(r);
            result = JObject.Parse(SomeeAdRemover(r));
            return result;
        }
    }


}
