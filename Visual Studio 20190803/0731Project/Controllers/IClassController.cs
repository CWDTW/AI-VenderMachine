using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using _0731Project.Models;
using System.Web.Http.Cors;


namespace projectWM.Controllers
{
    //[EnableCors(origins: "https://wisemachinewebapp.azurewebsites.net, http://wisemachinewebapp.azurewebsites.net", headers: "*", methods: "*")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class IClassController : ApiController
    {

        public WiseMachineEntities db = new WiseMachineEntities();
        //GET: api/Data
        public List<ItemDb> GetItemClass(string iclass)
        {
            var result = db.ItemDb
                  .Where(m => m.Class.Contains(iclass));
            return result.ToList();
        }

        // http://localhost:50237/api/Data/?iclass=飲料 //&time=2019 //名稱
        //[HttpGet] //類別
        //public IQueryable ItemClass(string iclass)//, string time)
        //{
        //    var result = db.ItemDb
        //         .Where(m => m.Class.Contains(iclass));
        //    //.Where(m => m.time.ToString().Contains(time));

        //    return result;
        //}
        //http://localhost:50237/api/Values/?asd=1
        [HttpGet] //全部
        public IQueryable<api2019> AllSalesData(string asd)
        {
            
            var result =  db.api2019
            .Where(m => m.ppp.ToString().Contains(asd));
            return result;
        }
        //http://localhost:50237/api/Values/?md=1
        [HttpGet] //上個月
        public IQueryable LastMonthData(string md)
        {
            var result = db.LastMonthApi
            .Where(m => m.ID.ToString().Contains(md));
            return result;
        }
        //http://localhost:50237/api/Values/?sd=1
        [HttpGet] //七天前
        public IQueryable LastSevenDaysData(string sd)
        {
            var result = db.LastSenvenDaysApi
            .Where(m => m.ID.ToString().Contains(sd));
            return result;
        }

    }
}
