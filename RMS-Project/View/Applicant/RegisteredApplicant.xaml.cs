using System.Net.Http;
using System.Text;
using System.Windows;
using Newtonsoft.Json;


namespace RMS_Project.View.Applicant
{
    /// <summary>
    /// Interaction logic for RegisteredApplicant.xaml
    /// </summary>
    public partial class RegisteredApplicant : Window
    {
        private readonly HttpClient _httpClient = new HttpClient();
        public RegisteredApplicant()
        {
            InitializeComponent();
        }

        private async void BtnSearch_OnClick(object sender, RoutedEventArgs e)
        {
            string identityCardNumber = txtSearch.Text.Trim();
            string requestUri = $"https://localhost:7019/Applicant/check?identityCardNumber={identityCardNumber}";

            try
            {
                var response = await _httpClient.GetAsync(requestUri);

                if (response.IsSuccessStatusCode)
                {
                    // Assuming JobList is a UserControl that you want to display
                    JobList jobList = new JobList(identityCardNumber); // Assuming you have a JobList UserControl
                    jobListPlaceholder.Content = jobList; // Load JobList UserControl into the placeholder
                }
                else
                {
                    MessageBox.Show("No applicant with the provided identity card number exists in the system.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"An error occurred: {ex.Message}", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }
}
