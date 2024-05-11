using RMS_Server.Models.Enums;

namespace RMS_Server.Models;

public class JobPosting
{
    public int JobPostingID { get; set; }
    public string Position { get; set; }
    public int Quantity { get; set; }
    public int PostingTime { get; set; }
    public DateTime StartTime { get; set; }
    public DateTime EndTime { get; set; }
    public string Requirements { get; set; }
    public int CompanyID { get; set; }
    public string FeedBack { get; set; }
    public Status Status { get; set; } = Status.Pending;
}