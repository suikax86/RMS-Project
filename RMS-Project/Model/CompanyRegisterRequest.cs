using RMS_Project.Model.Enums;

namespace RMS_Project.Model;

public class CompanyRegisterRequest
{
    public string CompanyName { get; set; }
    public string TaxIdentificationNumber { get; set; }
    public string Representative { get; set; }
    public string Email { get; set; }
    public string Address { get; set; }
}