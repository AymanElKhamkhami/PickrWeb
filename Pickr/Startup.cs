using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Pickr.Startup))]
namespace Pickr
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
