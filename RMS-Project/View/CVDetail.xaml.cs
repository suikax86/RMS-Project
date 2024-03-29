using System.Windows;

namespace PTTK_DuyetHoSo;

/// <summary>
///     Interaction logic for HienThiCV.xaml
/// </summary>
public partial class CVDetail : Window
{
    public CVDetail(string CV_ID)
    {
        InitializeComponent();
        CV_Text.Text = $"Thông tin chi tiết hồ sơ {CV_ID}";
    }
}