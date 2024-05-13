using System.Net.Http;
using System.Text.Json;
using System.Windows;
using RMS_Project.Model;

namespace RMS_Project.View.Windows;

public partial class ApplicantSubmission : Window
{
    private readonly HttpClient _httpClient = new HttpClient();
    public string IdentityCardNumber { get; set; } 
    private readonly object _selectedJob;

    public ApplicantSubmission(object selectedJob, string identityCardNumber)
    {
        _selectedJob = selectedJob;
        IdentityCardNumber = identityCardNumber;
        InitializeComponent();
        BindJobDetails();
    }
    
    
    private async void BindJobDetails()
    {
        if (_selectedJob != null)
        {
            
            dynamic job = _selectedJob;
            if (job != null)
            {
                txtCompanyName.Text = job.CompanyName;
                txtJobTitle.Text = job.Position;
                txtJobDescription.Text = job.Requirements;
                
            }
        }
        if (!string.IsNullOrEmpty(IdentityCardNumber))
        {
            var response = await _httpClient.GetAsync($"https://localhost:7019/Applicant?identityCardNumber={IdentityCardNumber}");
            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                // Bind candidate information to the UI
                txtApplicantContent.Text = content;
            }
        }

    }
    
    public void SetIdentityCardNumber(string identityCardNumber)
    {
        IdentityCardNumber = identityCardNumber;
        BindJobDetails(); 
    }

    
}

public class ApplicantDto
{
    public string ApplicantName { get; set; }
    public string IdentityCardNumber { get; set; }
    public string Gender { get; set; }
    public string Email { get; set; }
    public string ApplicantAddress { get; set; }
    public string DOB { get; set; }
}