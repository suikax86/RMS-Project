using System.Net.Http;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Navigation;
using RMS_Project.Services;
using RMS_Project.View.Windows;

namespace RMS_Project.View;

public partial class JobList : UserControl
{
    private readonly JobPostingService _jobPostingService = new JobPostingService(new HttpClient());
    private object selectedJob = null;
   

    public JobList()
    {
        InitializeComponent();
        Loaded += JobList_Loaded;
    }

    private async void JobList_Loaded(object sender, System.Windows.RoutedEventArgs e)
    {
        var jobPostings = await _jobPostingService.GetJobPostingsAsync();
        dgJobPostings.ItemsSource = jobPostings;
    }

    private void DgJobPostings_OnSelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        if (dgJobPostings.SelectedItem != null)
        {
            selectedJob = dgJobPostings.SelectedItem;
        }
    }

    private void ButtonBase_OnClick(object sender, RoutedEventArgs e)
    {
        
       ApplicantSubmission applicantSubmissionWindow = new ApplicantSubmission();
       applicantSubmissionWindow.ShowDialog(); // Use ShowDialog for a modal window or Show for a non-modal window

       

    }
}
