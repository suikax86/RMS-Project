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
using System.Windows.Shapes;

namespace PTTK_DuyetHoSo
{
    /// <summary>
    /// Interaction logic for HienThiCV.xaml
    /// </summary>
    public partial class CVDetail : Window
    {
        public CVDetail(string CV_ID)
        {
            InitializeComponent();
            CV_Text.Text = $"Thông tin chi tiết hồ sơ {CV_ID}";
        }
    }
}
