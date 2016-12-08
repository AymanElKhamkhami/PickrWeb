using Pickr.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Pickr.Models
{
    public class Request
    {
        public int RequestId { get; set; }
        public int OfferId { get; set; }
        public int UserId { get; set; }
        public Coordinates Start { get; set; }
        public Coordinates Destination { get; set; }
        public DateTime ArrivalFrom { get; set; }
        public DateTime ArrivalTo { get; set; }
        public int Seats { get; set; }
        public DateTime PickUp { get; set; }
        public bool Approved { get; set; }
        public bool Rejected { get; set; }
        public Offer Offer { get; set; } = new Offer();

        public Request()
        {
            Start = new Coordinates();
            Destination = new Coordinates();
        }
    }
}