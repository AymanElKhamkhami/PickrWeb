using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Pickr
{
    public partial class About : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["test"] != null) tst.Text = HttpContext.Current.Session["test"].ToString();
            else tst.Text = "session is null";

            string s = (1 + 2 / 4) + "";
        }
    }
}