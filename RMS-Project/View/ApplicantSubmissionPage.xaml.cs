using System.Windows;
using System.Windows.Controls;

namespace RMS_Project.View;

public partial class ApplicantSubmissionPage : UserControl
{
    private object selectedJob;
    public ApplicantSubmissionPage(object job)
    {
        InitializeComponent();
        selectedJob = job;
    }

    private void ButtonBase_OnClick(object sender, RoutedEventArgs e)
    {
        throw new NotImplementedException();
    }
}