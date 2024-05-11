using System.Windows;
using System.Windows.Controls;

namespace RMS_Project.View.UserControls;

public partial class MyTextBox : UserControl
{
    private string placeHolder;

    public MyTextBox()
    {
        InitializeComponent();
    }
    
    public static readonly DependencyProperty TextProperty = DependencyProperty.Register(
        "Text", typeof(string), typeof(MyTextBox), new PropertyMetadata(default(string), OnTextChanged));

    public string Text
    {
        get => (string)GetValue(TextProperty);
        set => SetValue(TextProperty, value);
    }
    
    private static void OnTextChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
    {
        if (d is MyTextBox myTextBox)
        {
            myTextBox.txtInput.Text = (string)e.NewValue;
        }
    }
    
    public string PlaceHolder
    {
        get => placeHolder;
        set
        {
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
        if (string.IsNullOrEmpty(txtInput.Text))
            txtPlaceHoder.Visibility = Visibility.Visible;
        else
            txtPlaceHoder.Visibility = Visibility.Hidden;
    }
}