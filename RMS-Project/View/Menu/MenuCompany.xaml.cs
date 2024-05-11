using RMS_Project.View.Company;
using System.Windows;

namespace RMS_Project.View.Windows
{
    /// <summary>
    /// Interaction logic for MenuCompany.xaml
    /// </summary>
    public partial class MenuCompany : Window
    {
        public MenuCompany()
        {
            InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            var companyRegister = new CompanyRegister();
            this.Hide();
            companyRegister.ShowDialog();
            this.Show();

        }
    }
}
