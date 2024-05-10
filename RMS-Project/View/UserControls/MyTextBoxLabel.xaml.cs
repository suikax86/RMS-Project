using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace RMS_Project.View.UserControls
{
    /// <summary>
    /// Interaction logic for MyTextBoxLabel.xaml
    /// </summary>
    public partial class MyTextBoxLabel : UserControl
    {
        public MyTextBoxLabel()
        {
            InitializeComponent();
        }

        public event EventHandler TextChanged;

        private void OnTextChanged()
        {
            TextChanged?.Invoke(this, EventArgs.Empty);
        }

        private string placeHolder;
        public string PlaceHolder
        {
            get { return placeHolder; }
            set
            {
                placeHolder = value;
                txtPlaceHoder.Text = placeHolder;
            }
        }

        private string labelInput;
        public string LabelInput
        {
            get { return labelInput; }
            set
            {
                labelInput = value;
                ipLabel.Content = labelInput;
            }
        }

        public string TextValue
        {
            get { return txtInput.Text; }
            set { txtInput.Text = value; }
        }
        private void btnClear_Click(object sender, RoutedEventArgs e)
        {
            txtInput.Clear();
            txtInput.Focus();
        }

        private void txtInput_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (string.IsNullOrEmpty(txtInput.Text))
            {
                txtPlaceHoder.Visibility = Visibility.Visible;
            }
            else
            {
                txtPlaceHoder.Visibility = Visibility.Hidden;
            }
            OnTextChanged();
        }
    }
}
