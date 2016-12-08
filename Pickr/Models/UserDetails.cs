using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Pickr.Models
{
    public class UserDetails
    {
        public string Email { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public int Reputation { get; set; }
        public Preferences Preferences { get; set; }
        public string CarModel { get; set; }
        public string FirstName { get; set; }
        public string Surname { get; set; }
        public DateTime Birth { get; set; }
        public string Gender { get; set; }
        public DateTime MemberSince { get; set; }
        public string Mobile { get; set; }
        public string Picture { get; set; }
        public string Address { get; set; }
        public string Mode { get; set; } = "passenger";

        public int CalculateAge()
        {
            DateTime today = DateTime.Today;
            int age = today.Year - Birth.Year;

            if (Birth > today.AddYears(-age))
                age--;

            return age;
        }
    }
}