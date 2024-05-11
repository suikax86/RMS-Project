namespace RMS_Project.Model;

public class JobPosting
{
    public int JobPostingID { get; set; }
    public string CompanyName { get; set; }
    public string Position { get; set; }
    public int Quantity { get; set; }
    public DateTime PostingTime { get; set; }
    public DateTime StartTime { get; set; }
    public DateTime EndTime { get; set; }
    public string Requirements { get; set; }
    public string CompanyAddress { get; set; }
}