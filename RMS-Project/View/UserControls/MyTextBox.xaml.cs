using System.Windows;
using System.Windows.Controls;

namespace RMS_Project.View.UserControls;

public partial class MyTextBox : UserControl
{
    public MyTextBox()
    {
        InitializeComponent();
    }
    
    private string placeHolder;
    public string PlaceHolder   
    {
        get { return placeHolder; }
        set { 
            placeHolder = value;
            txtPlaceHoder.Text = placeHolder;
        }
    }
    private void btnClear_Click(object sender, RoutedEventArgs e)
    {
        txtInput.Clear();
        txtInput.Focus();
    }

    private void txtInput_TextChanged(object sender, TextChangedEventArgs e)
    {
        if(string.IsNullOrEmpty(txtInput.Text)) {
            txtPlaceHoder.Visibility = Visibility.Visible;
        } else
        {
            txtPlaceHoder.Visibility = Visibility.Hidden;
        }
    }
}