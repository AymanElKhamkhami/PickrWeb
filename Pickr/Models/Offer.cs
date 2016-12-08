using Pickr.Classes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Pickr.Models
{
    public class Offer
    {
        public int OfferId { get; set; }
        public int UserId { get; set; }
        public Coordinates Start { get; set; }
        public Coordinates Destination { get; set; }
        public List<Coordinates> Waypoints { get; set; }
        public List<Coordinates> RoutePoints { get; set; }
        public List<Coordinates> RangeIndices { get; set; }
        public DateTime Departure { get; set; }
        public DateTime Arrival { get; set; }
        public int Seats { get; set; }
        public int ReservedSeats { get; set; }
        public double Price { get; set; }
        public int Radius { get; set; }
        public double Distance { get; set; }
        public bool Active { get; set; }

        public Offer()
        {
            Start = new Coordinates();
            Destination = new Coordinates();
            Waypoints = new List<Coordinates>();
            RoutePoints = new List<Coordinates>();
            RangeIndices = new List<Coordinates>();
        }
    }
}