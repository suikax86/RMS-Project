using RMS_Project.Model;
using RMS_Project.Model.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace RMS_Project.View.Applicant
{
    /// <summary>
    /// Interaction logic for ApplicantRegister.xaml
    /// </summary>
    public partial class ApplicantRegister : Window
    {
        private static readonly HttpClient client = new HttpClient();

        public ApplicantRegister()
        {
            InitializeComponent();
        }


        private async void ButtonBase_OnClick(object sender, RoutedEventArgs e)
        {
            var applicant = new ApplicantRegisterRequest
            {
                ApplicantName = NameTextBox.Text,
                IdentityCardNumber = CMNDTextBox.Text,
                Gender = MaleRadioButton.IsChecked == true ? Gender.MALE : Gender.FEMALE,
                Email = EmailTextBox.Text,
                ApplicantAddress = AddressTextBox.Text,
                DOB = DobDatePicker.SelectedDate.Value
            };

            var json = JsonSerializer.Serialize(applicant);
            var content = new StringContent(json, Encoding.UTF8, "application/json");

            try
            {
                var response = await client.PostAsync("https://localhost:7019/Applicant/register", content);
                var responseString = await response.Content.ReadAsStringAsync();

                if (response.IsSuccessStatusCode)
                {
                    MessageBox.Show("Applicant registered successfully!", "Successfully",MessageBoxButton.OK,MessageBoxImage.Information);
                }
                else
                {
                    MessageBox.Show($"Failed to register applicant: {responseString}","Failed", MessageBoxButton.OK, MessageBoxImage.Error);
                }
                // Close the current window
                this.Close();

            }
            catch (Exception ex)
            {
                MessageBox.Show($"An error occurred: {ex.Message}");
            }
        }
    }
}
