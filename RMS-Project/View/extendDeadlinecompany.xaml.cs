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
using System.ComponentModel;
using System.Windows;

namespace RMS_Project.View
{
    public partial class MainWindow : Window, INotifyPropertyChanged
    {
        private string _namecompany;
        public string Namecompany
        {
            get { return _namecompany; }
            set
            {
                _namecompany = value;
                OnPropertyChanged(nameof(Namecompany));
            }
        }

        private DateTime _currentApplicationTime = DateTime.Now;
        public DateTime CurrentApplicationTime
        {
            get { return _currentApplicationTime; }
            set
            {
                _currentApplicationTime = value;
                OnPropertyChanged(nameof(CurrentApplicationTime));
            }
        }

        private DateTime _deadline = DateTime.Now.AddDays(3);
        public DateTime Deadline
        {
            get { return _deadline; }
            set
            {
                _deadline = value;
                OnPropertyChanged(nameof(Deadline));
            }
        }

        private int _additionalDays;
        public int AdditionalDays
        {
            get { return _additionalDays; }
            set
            {
                _additionalDays = value;
                OnPropertyChanged(nameof(AdditionalDays));
            }
        }

        private string _renewalResult;
        public string RenewalResult
        {
            get { return _renewalResult; }
            set
            {
                _renewalResult = value;
                OnPropertyChanged(nameof(RenewalResult));
            }
        }

        public MainWindow()
        {
            InitializeComponent();
            DataContext = this;
            Namecompany = "công ty thịnh phát";
        }

        private void RenewButtonClick(object sender, RoutedEventArgs e)
        {
            CurrentApplicationTime = CurrentApplicationTime.AddDays(AdditionalDays);
            Deadline = Deadline.AddDays(AdditionalDays);
            RenewalResult = $"Đã gia hạn thời gian ứng tuyển thêm {AdditionalDays} ngày cho công ty {Namecompany}.";
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected virtual void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}

