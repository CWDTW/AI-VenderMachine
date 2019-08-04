using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace _0731Project.Models
{
    public class testViewModel
    {
        public List<EmpDb> emps { get; set; }
        public List<ItemDb> items { get; set; }
        public List<MachineStorageDb> stores { get; set; }
    }
}