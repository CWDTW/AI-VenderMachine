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
    public class MonthController : ApiController
    {
        WiseMachineEntities db = new WiseMachineEntities();
        //get
        public List<LastMonthApi> GetLastMonth()
        {
            var result = db.LastMonthApi.ToList();
            return result;
        }      
    }
}
