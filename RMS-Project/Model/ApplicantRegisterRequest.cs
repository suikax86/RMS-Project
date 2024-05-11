using RMS_Project.Model.Enums;

namespace RMS_Project.Model;

public class ApplicantRegisterRequest
{
    public string ApplicantName { get; set; }
    public string IdentityCardNumber { get; set; }
    public Gender Gender { get; set; }
    public string Email { get; set; }
    public string ApplicantAddress { get; set; }
    public DateTime DOB { get; set; }
}