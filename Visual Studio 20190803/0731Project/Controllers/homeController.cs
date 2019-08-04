using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.Entity;
using _0731Project.Models;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System.Net.Http;
using System.Text;
using System.Data;
using PagedList;
using PagedList.Mvc;
using System.Web.Http.Cors;
using System.IO;


namespace _0731Project.Controllers
{
    public class AllowCORSAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            filterContext.RequestContext.HttpContext.Response.AddHeader("Access-Control-Allow-Origin", "*");
            filterContext.RequestContext.HttpContext.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type");
            filterContext.RequestContext.HttpContext.Response.AddHeader("Access-Control-Allow-Methods", "POST");

            base.OnActionExecuting(filterContext);
        }
    }

    //[EnableCors(origins: "https://wisemachinewebapp.azurewebsites.net, http://wisemachinewebapp.azurewebsites.net", headers: "*", methods: "*")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class HomeController : Controller
    {
        WiseMachineEntities db = new WiseMachineEntities();

        //private int pagesize = 10;
        // GET: home
        public ActionResult Index()
        {
            if (Session["Member"] == null)
            {
                return RedirectToAction("Login");
            }

            var x = from oE in db.EmpDb
                    from oM in db.MachineDb
                    where oE.MachineId == oM.MachineId
                    select oE;

            return View(x.ToList());
        }

        //登入
        [HttpGet]
        public ActionResult Login()
        {
            Session.RemoveAll();
            HttpCookie cookie = Request.Cookies["user"];
            if (cookie != null)
            {
                ViewBag.username = cookie["username"];
                //DECRYPT PASSWORD
                string EncryptedPassword = cookie["password"];
                byte[] b = Convert.FromBase64String(EncryptedPassword);
                string decryptPassword = ASCIIEncoding.ASCII.GetString(b);
                ViewBag.password = decryptPassword;
            }
            var user = db.EmpDb.ToList();
            return View(user);
        }
        //登入POST
        [HttpPost]
        public ActionResult Login(string useracc, string userpw, string rememberMe)
        {
            Session.RemoveAll();
            var member = db.EmpDb.Where(m => m.Account == useracc && m.PassWord == userpw).FirstOrDefault();
            if (member == null)
            {
                ViewBag.msg = "無此帳號或密碼錯誤,請聯絡管理員.";
                ViewBag.check = "skip";
                return View();
            }
            Session["Welcome"] = "歡迎回來, " + member.EmployeeName;
            Session["EName"] = member.EmployeeName;
            Session["EID"] = member.EmployeeID;
            Session["Member"] = member;
            Session["Permission"] = member.Permission;
            //使用cookie>記住我功能
            HttpCookie cookie = new HttpCookie("user");
            if (rememberMe != null)
            {
                cookie["username"] = useracc;
                //ENCRYPT PASSWORD
                byte[] b = ASCIIEncoding.ASCII.GetBytes(userpw);
                string EncryptedPassword = Convert.ToBase64String(b);
                cookie["password"] = EncryptedPassword;
                cookie.Expires = DateTime.Now.AddDays(2);
                HttpContext.Response.Cookies.Add(cookie);
            }
            else
            {
                cookie.Expires = DateTime.Now.AddDays(-1);
                HttpContext.Response.Cookies.Add(cookie);
            }

            if (Session["Permission"].ToString() == "1")
            {
                return RedirectToAction("Index");
            }
            else
            {
                if (Session["Member"] == null)
                {
                    return RedirectToAction("Login");
                }
                var query = from obj in db.EmpDb
                            select obj;
                return View("EmployeeCondition", "_Layout3", query.ToList());
            }
        }

        //員工狀態
        [HttpGet]
        public ActionResult EmployeeCondition()
        {
            var x = from o in db.EmpDb
                    orderby o.EmployeeID ascending
                    select o;
            if (Session["Member"] == null)
            {
                return RedirectToAction("Login");
            }
            if (Session["Permission"].ToString() == "1")
            {
                return View(x.ToList());
            }
            else
            {
                return View("EmployeeCondition", "_Layout3", x.ToList());
            }
        }


        //員工狀態POST
        [HttpPost]
        public ActionResult EmployeeCondition(string eid, string ename, string eassi, string emach, string eacc)
        {
            var x = from o in db.EmpDb
                    orderby o.EmployeeID ascending
                    select o;
            //卡登入
            if (Session["Member"] == null)
            {
                return RedirectToAction("Login");
            }
            //卡上班狀態
            if (eassi == "上班" || eassi == "1")
            {
                eassi = "1";
            }
            else if (eassi == "請假" || eassi == "0")
            {
                eassi = "0";
                emach = "0";
            }
            else
            {
                ViewBag.alertt = "輸入錯誤,請重輸";
            }
            EmpDb emp = new EmpDb
            {
                EmployeeID = eid,
                EmployeeName = ename,
                Assignment = Convert.ToInt32(eassi),
                MachineId = emach,
                Account = eacc
            };
            //db.Configuration.ValidateOnSaveEnabled = false;
            db.EmpDb.Attach(emp);
            db.Entry(emp).Property(m => m.EmployeeName).IsModified = true;
            db.Entry(emp).Property(m => m.Assignment).IsModified = true;
            db.Entry(emp).Property(m => m.MachineId).IsModified = true;
            db.Entry(emp).Property(m => m.Account).IsModified = true;
            db.SaveChanges();

            //db.Entry(emp).State = EntityState.Unchanged;
            //db.Entry(emp).State = EntityState.Modified;

            if (Session["Permission"].ToString() == "1")
            {
                return View(x.ToList());
            }
            else
            {
                return View("EmployeeCondition", "_Layout3", x.ToList());
            }
        }

        //員工編輯
        [HttpGet]
        public ActionResult EmployeeEdit()
        {
            if (Session["Member"] == null)
            {
                return RedirectToAction("Login");
            }
            var x = from o in db.EmpDb
                    orderby o.EmployeeID
                    select o;
            return View(x.ToList());
            //Ixable<EmpDb> empM = empMethod();
        }
        //員工編輯POST
        [HttpPost]
        public ActionResult EmployeeEdit(string eid, string ename, string eacc, string epw, string epho, string eadd, string esex, string ebir, string email, string eaddr, string eper)
        {
            if (Session["Member"] == null)
            {
                return RedirectToAction("Login");
            }
            var x = from o in db.EmpDb
                    orderby o.EmployeeID
                    select o;
            //if (edate != "yyyy/MM/dd" || edate != "yyyy-MM-dd")
            //{
            //    ViewBag.msg = "日期錯誤,請重新輸入";
            //}
            //var emp = db.EmpDbs.Find(ename);
            EmpDb emp = new EmpDb
            {
                EmployeeID = eid,
                EmployeeName = ename,
                Account = eacc,
                PassWord = epw,
                PhoneNum = epho.Trim(),
                AddDate = eadd.Replace('-', '/'),
                Sex = esex.ToUpper(),
                Birthday = ebir.Replace('-', '/'),
                Email = email,
                Address = eaddr,
                UpdateTime = DateTime.Now.ToString("yyyy/MM/dd"),
                Permission = Convert.ToInt32(eper),
            };

            //Modified要在.IsModified前

            db.Entry(emp).State = EntityState.Modified;
            db.Entry(emp).Property(m => m.EmployeeID).IsModified = false;
            db.Entry(emp).Property(m => m.Assignment).IsModified = false;
            db.Entry(emp).Property(m => m.MachineId).IsModified = false;
            try
            {
                db.SaveChanges();
            }
            catch (Exception)
            {

                return View(x.ToList());
            }

            return View(x.ToList());
        }

        //員工新增POST
        [HttpPost]
        public ActionResult CreateEmp(string eeacc, string eepass, string eename, string eepho, string eesex, string eemail,
            string eeaddr, string eebir, string eeper)
        {
            var x = db.EmpDb.AsNoTracking().Where(m => m.Account == eeacc).FirstOrDefault();
            if (x == null)
            {
                //計算資料筆數成ID編號
                var eeid = db.EmpDb.Count();
                EmpDb eemp = new EmpDb
                {
                    Account = eeacc,
                    PassWord = eepass,
                    EmployeeName = eename,
                    EmployeeID = (eeid + 1).ToString().Trim(),
                    PhoneNum = eepho,
                    Sex = eesex.ToUpper(),
                    Email = eemail,
                    Address = eeaddr,
                    Birthday = eebir,
                    AddDate = DateTime.Now.ToString("yyyy/MM/dd"),
                    UpdateTime = DateTime.Now.ToString("yyyy/MM/dd"),
                    Permission = Convert.ToInt32(eeper),
                    Assignment = 0,
                    MachineId = "0"
                };

                db.EmpDb.Add(eemp);
                try
                {
                    db.SaveChanges();
                }
                catch (Exception)
                {

                    goto CreateError;
                }

            }
            else
            {

                ViewBag.CreateError = "帳號重複,請重新建立";
            }
            CreateError:
            return RedirectToAction("EmployeeEdit");
        }
        //員工編輯刪除
        public ActionResult EmployeeDelete(string eid)
        {
            var eempss = db.EmpDb.Where(m => m.EmployeeID == eid).FirstOrDefault();
            var x = from o in db.EmpDb
                    where o.EmployeeID == eid
                    select o;
            db.EmpDb.Remove(eempss);
            try
            {
                db.SaveChanges();
            }
            catch (Exception)
            {

                return RedirectToAction("EmployeeEdit");
            }


            return RedirectToAction("EmployeeEdit");
        }


        //機臺狀態
        public ActionResult MachineCondition()
        {
            if (Session["Member"] == null)
            {
                return RedirectToAction("Login");
            }
            var x = from o in db.MachineDb
                    select o;
            for (int i = 1; i < 11; i++)
            {
                var y = db.MachineStorageDb.Where(m => m.Rack == i.ToString()).FirstOrDefault();
                if (Convert.ToInt32(y.Amount) <= 3)
                {
                    ViewBag.toolow = "需要補貨";
                }

            }

            if (Session["Permission"].ToString() == "1")
            {
                return View(x.ToList());
            }
            else
            {
                return View("MachineCondition", "_Layout3", x.ToList());
            }
        }

        //機臺編輯
        public ActionResult MachineEdit()
        {

            if (Session["Member"] == null)
            {
                return RedirectToAction("Login");
            }
            //testViewModel x = new testViewModel();
            //var y = from obj in db.EmpDbs
            //        select obj;
            //var z = from obj in db.ItemDbs
            //        select obj;
            //var k = from obj in db.MachineStorageDbs
            //        select obj;

            //x.emps = y.ToList();
            //x.items = z.ToList();
            //x.wstores = k.ToList();
            var x = from o in db.MachineStorageView
                    select o;
            if (Session["Permission"].ToString() == "1")
            {
                return View(x.ToList());
            }
            else
            {
                return View("MachineEdit", "_Layout3", x.ToList());
            }
        }
        //機臺編輯POST
        [HttpPost]
        public ActionResult MachineEdit(string td1, string td2, string td3, string td4, string td5, string td6, string td7, string td8, string td9, string td10)
        {
            if (Session["Member"] == null)
            {
                return RedirectToAction("Login");
            }
            var x = from o in db.MachineStorageView
                    select o;
            //將View帶進來的值變為陣列
            string[] y = new string[] { td1, td2, td3, td4, td5, td6, td7, td8, td9, td10 };

            for (int i = 1; i < 11; i++)
            {
                //舊的值
                var original = db.MachineStorageDb.AsNoTracking().Where(m => m.Rack == i.ToString()).FirstOrDefault();
                //新的值
                var mwstores = db.MachineStorageDb.Where(m => m.Rack == i.ToString()).FirstOrDefault();
                mwstores.Amount = y[i - 1];
                //比較新舊更新
                if (mwstores.Amount == original.Amount)
                {
                    db.Entry(mwstores).Property(m => m.EmployeeId).IsModified = false;
                    db.Entry(mwstores).Property(m => m.UpdateTime).IsModified = false;
                }
                else
                {
                    mwstores.EmployeeId = Session["EID"].ToString();
                    db.Entry(mwstores).Property(m => m.EmployeeId).IsModified = true;
                    mwstores.UpdateTime = DateTime.Now.ToString("yyyy/MM/dd");
                    db.Entry(mwstores).Property(m => m.UpdateTime).IsModified = true;
                }
                db.Entry(mwstores).Property(m => m.Amount).IsModified = true;
            }
            try
            {
                db.SaveChanges();
                return View(x.ToList());
            }
            catch (Exception)
            {

                return View(x.ToList());
            }
        }



        //倉庫狀況
        public ActionResult WareHouseCondition()
        {
            if (Session["Member"] == null)
            {
                return RedirectToAction("Login");
            }
            var x = from o in db.WareHouseDb
                    select o;
            for (int i = 1; i < 50; i++)
            {
                try
                {
                    var y = db.WareHouseStorageView.Where(m => m.Rack == i.ToString()).FirstOrDefault();
                    if (Convert.ToInt32(y.Amount) <= 3)
                    {
                        ViewBag.tooolow = "需要叫貨";
                    }
                }
                catch (Exception)
                {

                    break;
                }

            }
            if (Session["Permission"].ToString() == "1")
            {
                return View(x.ToList());
            }
            else
            {
                return View("WareHouseCondition", "_Layout3", x.ToList());
            }
        }
        //倉庫編輯
        public ActionResult WareHouseEdit()
        {

            if (Session["Member"] == null)
            {
                return RedirectToAction("Login");
            }
            var x = from o in db.WareHouseStorageView
                    select o;
            if (Session["Permission"].ToString() == "1")
            {
                return View(x.ToList());
            }
            else
            {
                return View("WareHouseEdit", "_Layout3", x.ToList());
            }
        }

        //倉庫編輯POST
        [HttpPost]
        public ActionResult WareHouseEdit(string rc1, string rc2, string rc3, string rc4, string rc5, string rc6, string rc7, string rc8, string rc9, string rc10, string rc11, string rc12, string rc13, string rc14, string rc15, string rc16)
        {
            if (Session["Member"] == null)
            {
                return RedirectToAction("Login");
            }

            //將View帶進來的值變為陣列
            string[] y = new string[] { rc1, rc2, rc3, rc4, rc5, rc6, rc7, rc8, rc9, rc10, rc11, rc12, rc13, rc14, rc15, rc16 };

            for (int i = 1; i <= y.Length; i++)
            {
                //舊的值
                var original = db.WareHouseStorageDb.AsNoTracking().Where(m => m.Rack == i.ToString()).FirstOrDefault();
                //新的值
                var wstores = db.WareHouseStorageDb.Where(m => m.Rack == i.ToString()).FirstOrDefault();
                wstores.Amount = y[i - 1];
                //比較新舊更新
                if (wstores.Amount == original.Amount)
                {
                    db.Entry(wstores).Property(m => m.EmployeeId).IsModified = false;
                    db.Entry(wstores).Property(m => m.UpdateTime).IsModified = false;
                }
                else
                {
                    wstores.EmployeeId = Session["EID"].ToString();
                    db.Entry(wstores).Property(m => m.EmployeeId).IsModified = true;
                    wstores.UpdateTime = DateTime.Now.ToString("yyyy/MM/dd");
                    db.Entry(wstores).Property(m => m.UpdateTime).IsModified = true;
                }
                db.Entry(wstores).Property(m => m.Amount).IsModified = true;
            }

            db.SaveChanges();
            var x = from o in db.MachineStorageView
                    select o;
            return RedirectToAction("WareHouseCondition");
        }
        //商品編輯
        [HttpGet]
        public ActionResult ItemEdit()
        {
            if (Session["Member"] == null)
            {
                return RedirectToAction("Login");
            }
            var x = from o in db.ItemDb
                    orderby o.ItemId
                    select o;
            return View(x.ToList());
            //Ixable<EmpDb> empM = empMethod();
        }
        //商品編輯POST
        [HttpPost]
        public ActionResult ItemEdit(string iid, string iname, string iprice, string iclass, string icap, string ical, string iprot, string icar, string ifat, string isug, string isod, string islog1, string islog2)
        {
            ItemDb items = new ItemDb
            {
                ItemId = Convert.ToInt32(iid.Trim()),
                ItemName = iname,
                ItemUnitPrice = Convert.ToInt32(iprice.Trim()),
                Class = iclass,
                Capacity = icap,
                Calorles = ical,
                Protein = iprot,
                Carbohydrate = icar,
                Fat = ifat,
                Sugars = isug,
                Sodium = isod,
                Slogan1 = islog1,
                Slogan2 = islog2
            };
            db.Entry(items).State = EntityState.Modified;
            //db.Entry(items).Property(m => m.ItemId).IsModified = false;
            db.Entry(items).Property(m => m.ItemImg).IsModified = false;
            db.Entry(items).Property(m => m.ImgUrl).IsModified = false;
            db.Entry(items).Property(m => m.PayUrl).IsModified = false;
            try
            {
                db.SaveChanges();
            }
            catch (Exception)
            {

                goto Redirect;
            }
            
            Redirect:
            return RedirectToAction("ItemEdit");
        }
        //新增商品
        public ActionResult CreateItem( string iiname, string iiprice, HttpPostedFileBase iiimg, string iiclass, string iicap, string iical, string iiprot, string iicar, string iifat, string iisug, string iisod, string iislog1, string iislog2)
        {
            if (iiimg != null && iiimg.ContentLength > 0)
            {
                var imgname = iiimg.FileName;
                var path = Path.Combine(Server.MapPath("~/images"), imgname);
                iiimg.SaveAs(path);
                var x = db.ItemDb.Count();
                ItemDb items = new ItemDb
                {
                    ItemId = x + 1,
                    ItemName = iiname,
                    ItemImg = imgname,
                    ItemUnitPrice = Convert.ToInt32(iiprice.Trim()),
                    Class = iiclass,
                    Capacity = iicap,
                    Calorles = iical,
                    Protein = iiprot,
                    Carbohydrate = iicar,
                    Fat = iifat,
                    Sugars = iisug,
                    Sodium = iisod,
                    Slogan1 = iislog1,
                    Slogan2 = iislog2
                };
                db.ItemDb.Add(items);
                //db.Entry(items).Property(m => m.ItemImg).IsModified = false;
                //db.Entry(items).Property(m => m.ImgUrl).IsModified = false;
                //db.Entry(items).Property(m => m.PayUrl).IsModified = false;
                db.SaveChanges();

            }
            return RedirectToAction("ItemEdit");
        }
        public ActionResult DeleteItem(string iid)
        {
            int x = Convert.ToInt32(iid);
            var y = db.ItemDb.Where(m => m.ItemId == x).FirstOrDefault();

            db.ItemDb.Remove(y);

            db.SaveChanges();
            return RedirectToAction("ItemEdit");
        }


        //public ActionResult Chart()
        //{
        //    return View();
        //}


        //報表
        [AllowCORS]
        public ActionResult FinancialList(int? page)
        {
            int currenpage = page ?? 1;
            var products = from o in db.alltable
                           orderby o.ID
                           select o;
            var result = products.ToList().ToPagedList(currenpage, 10);
            if (Session["Member"] == null)
            {
                return RedirectToAction("Login");
            }
            if (Session["Permission"].ToString() == "1")
            {
                return View(result);
            }
            else
            {
                return RedirectToAction("Login");
            }

            //int page =1
            //int currenpage = page < 1 ? 1 : page;
            //var products = db.alltable.OrderBy(m => m.CID).ToList();

        }



        //TingYing
        public ActionResult Index1()
        {
            var hotItem = db.ItemDb.Where(m => m.Slogan2.Contains("TOP")).OrderBy(m => m.Slogan2).ToList();
            return View("Index1", "_Layout1", hotItem);
        }


        public ActionResult Product()
        {
            var product = db.ItemDb.ToList();
            var sosItemList = db.MachineStorageDb.Where(m => m.Amount == "0").ToList();
            foreach (var item in sosItemList)
            {
                ViewBag.sosItem += item.ItemId + ",";
            }
            return View("Product", "_Layout1", product);
        }
        private static Dictionary<string, object> OrderTransactions = new Dictionary<string, object>();

        [HttpPost]
        public async Task<ActionResult> Reserve(int ItemId, bool capture = true)
        {



            var item = db.ItemDb.Where(m => m.ItemId == ItemId).SingleOrDefault();
            var param = new
            {
                productName = item.ItemName,
                productImageUrl = item.ImgUrl,
                amount = item.ItemUnitPrice,
                currency = "TWD",
                confirmUrl = "https://wisemachinewebapp.azurewebsites.net/home/Confirm",
                orderId = $"ORDER-{DateTime.Now:yyyyMMdd_HHmmss}",
                capture = capture
            };


            // *** call RESERVE API
            var responseJson = await RequestGateway("request", param);
            dynamic responseObj = JObject.Parse(responseJson);
            ViewBag.ResponseJson = JsonConvert.SerializeObject(responseObj, Formatting.Indented);
            if (responseObj.returnCode == "0000")
            {
                OrderTransactions[responseObj.info.transactionId.ToString()] = param;
                ViewBag.PaymentUrl = responseObj.info.paymentUrl.web;
            }
            string PaymentUrl = responseObj.info.paymentUrl.web;


            SalesStatisticsDb order = new SalesStatisticsDb();
            order.ItemId = ItemId;
            //order.TransactionId = responseObj.info.transactionId;
            order.MachineId = "1";
            order.UpdateTime = DateTime.Now.ToString("yyyy/MM/dd");
            //order.Amount = 1;
            db.SalesStatisticsDb.Add(order);
            db.SaveChanges();

            return Redirect(PaymentUrl);

        }

        [HttpGet]
        public async Task<ActionResult> Confirm(string transactionId)
        {
            dynamic transaction = OrderTransactions[transactionId];

            var param = new
            {
                amount = transaction.amount,
                currency = transaction.currency
            };

            // *** call CONFIRM API
            var responseJson = await RequestGateway($"{transactionId}/confirm", param);
            dynamic responseObj = JObject.Parse(responseJson);
            ViewBag.ResponseJson = JsonConvert.SerializeObject(responseObj, Formatting.Indented);

            if (responseObj.returnCode == "0000")
            {
                ViewBag.TransactionId = transactionId;
                ViewBag.Captured = transaction.capture;
            }

            return RedirectToAction("PayOK");
        }

        private async Task<string> RequestGateway(string path, object param)
        {
            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Add("X-LINE-ChannelId", "1597611346");
                client.DefaultRequestHeaders.Add("X-LINE-ChannelSecret", "65dc3f3d1b562a3028cbd52b5a3d57a6");

                var content = new StringContent(JsonConvert.SerializeObject(param), Encoding.UTF8, "application/json");

                var response = await client.PostAsync("https://sandbox-api-pay.line.me/v2/payments/" + path, content);
                return await response.Content.ReadAsStringAsync();
            }
        }


        public ActionResult PayOK()
        {
            return View("PayOK", "_Layout2");
        }

    }

}