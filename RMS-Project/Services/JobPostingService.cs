using System.Net.Http;
using System.Threading.Tasks;
using System.Collections.Generic;
using RMS_Project.Model;
using System.Text.Json;

namespace RMS_Project.Services;

public class JobPostingService
{
    private readonly HttpClient _httpClient;
    public JobPostingService(HttpClient httpClient)
    {
        _httpClient = httpClient;
    }

    public async Task<List<JobPosting>> GetJobPostingsAsync(string sortBy = "StartTime", string sortOrder = "ASC")
    {
        string url = $"https://localhost:7019/JobPosting/job-postings";
        
        var options = new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true,
            Converters = { new CustomDateTimeConverter("yyyy-MM-ddTHH:mm:ss") } 
        };

        var response = await _httpClient.GetAsync(url);
        if (response.IsSuccessStatusCode)
        {
            var json = await response.Content.ReadAsStringAsync();
            var jobPostings = JsonSerializer.Deserialize<List<JobPosting>>(json, options);
            return jobPostings ?? new List<JobPosting>();
        }
        return new List<JobPosting>();
    }
}