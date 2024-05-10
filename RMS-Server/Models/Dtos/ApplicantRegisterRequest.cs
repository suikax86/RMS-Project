using RMS_Server.Models.Enums;

namespace RMS_Server.Models.Dtos;

public class ApplicantRegisterRequest
{
    public string ApplicantName { get; set; }
    public string IdentityCardNumber { get; set; }
    public Gender Gender { get; set; } = Gender.MALE;
    public string Email { get; set; }
    public string ApplicantAddress { get; set; }
    public string DOB { get; set; }
}