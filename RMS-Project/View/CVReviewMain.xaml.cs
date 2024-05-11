using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Navigation;
using RMS_Project.View;

namespace PTTK_DuyetHoSo;

/// <summary>
///     Interaction logic for MainWindow.xaml
/// </summary>
public partial class CVReviewMain : Window
{

    public ObservableCollection<CV> cvList { get; set; }

    public CVReviewMain()
    {
        InitializeComponent();
        DataContext = this;
        // Mock data
        cvList = new ObservableCollection<CV>
        {
            new() { CV_ID = "CV1", Position = "Manager", Company = "Company A", Status = "unprocessed" },
            new() { CV_ID = "CV2", Position = "Software Engineer", Company = "Company A", Status = "unprocessed" },
            new() { CV_ID = "CV3", Position = "Data Analyst", Company = "Company B", Status = "unprocessed" },
            new() { CV_ID = "CV4", Position = "Product Manager", Company = "Company C", Status = "unprocessed" },
            new() { CV_ID = "CV5", Position = "UX Designer", Company = "Company D", Status = "unprocessed" }
        };
    }

    private void ListView_MouseDoubleClick(object sender, MouseEventArgs e)
    {
        var selectedItems = CVList_ListView.SelectedItems;
        if (selectedItems.Count > 0)
        {
            var selectedItem = selectedItems[0] as CV;
            if (selectedItem != null)
            {
                var cvId = selectedItem.CV_ID;
                var detailsWindow = new CVDetail_Emp(cvId);
                detailsWindow.ShowDialog();
            }
        }
    }


}


public class CV
{
    public string CV_ID { get; set; }
    public string Position { get; set; }
    public string Company { get; set; }
    public string Status { get; set; }
    public bool IsChecked { get; set; }
}