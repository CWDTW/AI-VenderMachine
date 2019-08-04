using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using _0731Project.Models;
using System.Web.Http.Cors;

namespace _0731Project.Controllers
{
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class WeekController : ApiController
    {
        WiseMachineEntities db = new WiseMachineEntities();
        public List<LastSenvenDaysApi> GetLastWeek()
        {
            var result = db.LastSenvenDaysApi.ToList();
            return result;
        }
    }
}
