using System.Windows;

namespace RMS_Project.View.Menu
{
    /// <summary>
    /// Interaction logic for MenuApplicant.xaml
    /// </summary>
    public partial class MenuApplicant : Window
    {
        public MenuApplicant()
        {
            InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
           var applicantRegister = new RMS_Project.View.Applicant.ApplicantRegister();
           this.Hide();
           applicantRegister.ShowDialog();
           this.Show();
        }
    }
}
