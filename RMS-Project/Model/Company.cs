using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RMS_Project.Model
{
    public class Company
    {
        public string Name { get; set; }
        public DateTime ExpiryDate { get; set; }
        public bool NeedsRenewal { get; set; }
    }
}
