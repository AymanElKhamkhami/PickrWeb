using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;

namespace Pickr.Classes
{
    public class Coordinates
    {
        public double lat { get; set; }
        public double lng { get; set; }

        public Coordinates() { }

        public Coordinates(double x, double y)
        {
            lat = x;
            lng = y;
        }

        public Coordinates(string x, string y)
        {
            lat = double.Parse(x, CultureInfo.InvariantCulture);
            lng = double.Parse(y, CultureInfo.InvariantCulture);
        }
    }
}