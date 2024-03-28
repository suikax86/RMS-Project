using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace PTTK_DuyetHoSo
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class CVReviewMain : Window
    {

        CVProcessingList _processingList = new CVProcessingList();
        CVList _cvList;
        public CVReviewMain()
        {
            InitializeComponent();
            _processingList = new CVProcessingList();
            _cvList = new CVList();
            contentFrame.NavigationUIVisibility = System.Windows.Navigation.NavigationUIVisibility.Hidden;
        }

        private void TabControl_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            TabControl tabControl = sender as TabControl;
            int selectedIndex = tabControl.SelectedIndex; 

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
}