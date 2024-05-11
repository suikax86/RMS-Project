using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Windows;
using System.Windows.Controls;
using RMS_Project.Model;
using RMS_Project.Model.Enums;
using RMS_Project.Services;


namespace RMS_Project.View;

public partial class CompanyRegisterForm : UserControl
{

    private static readonly HttpClient client = new HttpClient();

    public CompanyRegisterForm()
    {
        InitializeComponent();
    }

    private async void ButtonBase_OnClick(object sender, RoutedEventArgs e)
    {
        var company = new CompanyRegisterRequest
        {
            CompanyName = ComapnyName_TextBox.Text,
            TaxIdentificationNumber = TaxIdentificationNumber_TextBox.Text,
            Representative = Representative_TextBox.Text,
            Email = Email_TextBox.Text,
            Address = Address_TextBox.Text,
        };

        var json = JsonSerializer.Serialize(company);
        var content = new StringContent(json, Encoding.UTF8, "application/json");

        try
        {
            var response = await client.PostAsync("https://localhost:7019/Company/register", content);
            var responseString = await response.Content.ReadAsStringAsync();

            if (response.IsSuccessStatusCode)
            {
                MessageBox.Show("Company registered successfully!","Successfully",MessageBoxButton.OK,MessageBoxImage.Information);
            }
            else
            {
                MessageBox.Show($"Failed to register Company: {responseString}","", MessageBoxButton.OK, MessageBoxImage.Error);
            }
            // then close the form
            Window.GetWindow(this)?.Close();
        }
        catch (Exception ex)
        {
            MessageBox.Show($"An error occurred: {ex.Message}");
        }
    }
}