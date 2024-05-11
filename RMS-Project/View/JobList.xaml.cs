using System.Net.Http;
using System.Windows.Controls;
using RMS_Project.Services;

namespace RMS_Project.View;

public partial class JobList : UserControl
{
    private readonly JobPostingService _jobPostingService = new JobPostingService(new HttpClient());

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
}