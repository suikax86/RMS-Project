using System.Windows;
using System.Windows.Controls;
using System.Windows.Navigation;

namespace PTTK_DuyetHoSo;

/// <summary>
///     Interaction logic for MainWindow.xaml
/// </summary>
public partial class CVReviewMain : Window
{
    private readonly CVList _cvList;

    private readonly CVProcessingList _processingList = new();

    public CVReviewMain()
    {
        InitializeComponent();
        _processingList = new CVProcessingList();
        _cvList = new CVList();
        contentFrame.NavigationUIVisibility = NavigationUIVisibility.Hidden;
    }

    private void TabControl_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        var tabControl = sender as TabControl;
        var selectedIndex = tabControl.SelectedIndex;

        switch (selectedIndex)
        {
            case 0:
                contentFrame.Content = _cvList;
                break;

            case 1:
                contentFrame.Content = _processingList;
                break;
        }
    }
}