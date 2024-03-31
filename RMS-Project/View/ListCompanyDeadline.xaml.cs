using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace RMS_Project.View
{
    public partial class NearExpiryCompaniesWindow : Window
    {
        public ObservableCollection<Company> NearExpiryCompanies { get; set; }

        public NearExpiryCompaniesWindow()
        {
            InitializeComponent();
            DataContext = this;
            NearExpiryCompanies = new ObservableCollection<Company>
            {
                new Company { Name = "Company A", ExpiryDate = DateTime.Now.AddDays(2) },
                new Company { Name = "Company B", ExpiryDate = DateTime.Now.AddDays(1) },
                new Company { Name = "Company C", ExpiryDate = DateTime.Now.AddDays(3) }
            };
        }
        private void RenewButtonClick(object sender, RoutedEventArgs e)
        {
        }
    }

    public class Company
    {
        public string Name { get; set; }
        public DateTime ExpiryDate { get; set; }
        public bool NeedsRenewal { get; set; }
    }
}

