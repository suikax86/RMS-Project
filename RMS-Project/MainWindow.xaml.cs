using RMS_Project.View.Menu;
using RMS_Project.View.Windows;
using System.Windows;

namespace RMS_Project;

/// <summary>
///     Interaction logic for MainWindow.xaml
/// </summary>
public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
    }

    private void Button_Click(object sender, RoutedEventArgs e)
    {
        var menuCompany = new MenuCompany();
        this.Hide();
        menuCompany.ShowDialog();
        this.Close();

    }

    private void Button_Click_1(object sender, RoutedEventArgs e)
    {
        var menuApplicant = new MenuApplicant();
        this.Hide();
        menuApplicant.ShowDialog();
        this.Close();


    }

    private void Button_Click_2(object sender, RoutedEventArgs e)
    {

    }
}