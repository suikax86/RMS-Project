using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Globalization;
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

namespace RMS_Project.View
{
    public partial class JobPosting : UserControl
    {
        public JobPosting()
        {
            DataContext = this;
            entries = new ObservableCollection<string>();
            InitializeComponent();
            LabelErrorQuantity.Visibility = Visibility.Visible;
            LabelErrorDate = (Label)this.FindName("LabelErrorDate");
            string[] additionalEntriesArray =
            {
                "Đăng tuyển trên báo giấy",
                "Đăng trên các trang mạng",
                "Banner quảng cáo"
            };
            foreach (var entry in additionalEntriesArray)
            {
                Entries.Add(entry);
            }
        }
        private ObservableCollection<string> entries;
        public ObservableCollection<string> Entries
        {
            get { return entries; }
            set { entries = value; }
        }
        private DateTime _currentDate;

        private void btnSend_Click(object sender, RoutedEventArgs e)
        {
            DateTime? startDate = DateStart.SelectedDate;
            DateTime? endDate = DateEnd.SelectedDate;
            TimeSpan difference = endDate.Value - startDate.Value;
            int daysDifference = (int)difference.TotalDays;
            //DateTime? startDate = DateStart.SelectedDate;
            //DateTime? endDate = DateEnd.SelectedDate;
            string position = txtPosition.TextValue;
            string quantityText = txtQuantity.TextValue;
            string TimeText = txtTimeJob.TextValue;
            string requirements = txtRequirements.TextValue;
            bool isQuantityEmpty = string.IsNullOrEmpty(quantityText);
            bool isTimeEmpty = string.IsNullOrEmpty(TimeText);
            bool isQuantityValid = !string.IsNullOrEmpty(quantityText) && int.TryParse(quantityText, out int quantity) && quantity > 0;
            bool isTimeValid = !string.IsNullOrEmpty(TimeText) && int.TryParse(TimeText, out int time) && time > 0;
            bool isPositionEmpty = string.IsNullOrEmpty(position);
            bool isRequirementsEmpty = string.IsNullOrEmpty(requirements);
            bool error = false;
            if (isQuantityEmpty || isPositionEmpty || isRequirementsEmpty || isTimeEmpty)
            {
                MessageBox.Show("Vui lòng điền đầy đủ thông tin");
                return;
            }
            if (!isQuantityValid)
            {
                LabelErrorQuantity.Content = "Số lượng điền vào phải là một số lớn hơn 0";
                error = true;
            }
            if (!isTimeValid)
            {
                LabelErrorTimeJob.Content = "Khoảng thời gian điền vào phải là một số lớn hơn 0";
                error = true;
            }
            if (startDate.HasValue && endDate.HasValue)
            {
                if (startDate.Value >= endDate.Value)
                {
                    LabelErrorDate.Content = "Ngày kết thúc phải sau ngày bắt đầu ít nhất 1 ngày";
                    error = true;
                }

            }
            string selectedItem = (string)lvMethodPosting.SelectedItem;
            if (selectedItem == null)
            {
                MessageBox.Show("Vui lòng chọn hình thức thanh toán");
                return;
            }
            //}
            if (error)
            {
                return;
            }
            if (daysDifference != int.Parse(TimeText))
            {
                MessageBox.Show("Khoảng thời gian giữa ngày bắt đầu và ngày kết thúc không đúng");
                return;
            }
            //JobPostingMoreInfo jobpostingMore = new JobPostingMoreInfo();
            //jobpostingMore.ShowDialog();
        }
        private void txtQuantity_TextChanged(object sender, EventArgs e)
        {
            LabelErrorQuantity.Content = ""; 
        }
        private void txtTimeJob_TextChanged(object sender, EventArgs e)
        {
            LabelErrorTimeJob.Content = "";
        }

        //private void DateStart_SelectedDateChanged(object sender, SelectionChangedEventArgs e)
        //{
        //    if (LabelErrorDate != null)
        //    {
        //        LabelErrorDate.Content = "";
        //    }
        //}

        //private void DateEnd_SelectedDateChanged(object sender, SelectionChangedEventArgs e)
        //{
        //    if (LabelErrorDate != null)
        //    {
        //        LabelErrorDate.Content = "";
        //    }
        //}
        private void DateStart_SelectedDateChanged(object sender, SelectionChangedEventArgs e)
        {
            if (LabelErrorDate != null)
            {
                LabelErrorDate.Content = "";
            }
        }

        private void DateEnd_SelectedDateChanged(object sender, SelectionChangedEventArgs e)
        {
            if (LabelErrorDate != null)
            {
                LabelErrorDate.Content = "";
            }
        }
    }
}
