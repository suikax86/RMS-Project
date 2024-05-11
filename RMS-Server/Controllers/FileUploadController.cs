using Microsoft.AspNetCore.Mvc;

namespace RMS_Server.Controllers;

[ApiController]
[Route("controller")]
public class FileUploadController : ControllerBase
{
    [HttpPost]
    [Route("upload/{folderPath}")]
    public async Task<IActionResult> UploadFile(IFormFile file, string folderPath)
    {
        if (file == null || file.Length == 0)
        {
            return BadRequest("No file uploaded.");
        }

        var allowedTypes = new[] { "application/pdf", "image/jpeg", "image/png", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document" };
        if (!allowedTypes.Contains(file.ContentType))
        {
            return BadRequest("File type is not allowed.");
        }

        var path = Path.Combine(Directory.GetCurrentDirectory(), "UploadedFiles", folderPath);
        if (!Directory.Exists(path))
        {
            Directory.CreateDirectory(path);
        }

        var savePath = Path.Combine(path, file.FileName);

        using (var fileStream = new FileStream(savePath, FileMode.Create))
        {
            await file.CopyToAsync(fileStream);
        }

        return Ok(new { Message = "File uploaded successfully." });
    }
    
    [HttpGet]
    [Route("download/{fileName}")]
    public IActionResult DownloadFile(string fileName)
    {
        var filePath = Path.Combine(Directory.GetCurrentDirectory(), "UploadedFiles", fileName);
        if (!System.IO.File.Exists(filePath))
        {
            return NotFound();
        }

        var mimeType = "application/octet-stream";
        var fileBytes = System.IO.File.ReadAllBytes(filePath);
        return File(fileBytes, mimeType, fileName);
    }
    
    [HttpGet]
    [Route("files/{folderPath}")]
    public IActionResult ListFiles(string folderPath)
    {
        var path = Path.Combine(Directory.GetCurrentDirectory(), "UploadedFiles", folderPath);
        if (!Directory.Exists(path))
        {
            return NotFound("Folder not found.");
        }

        var files = Directory.GetFiles(path).Select(Path.GetFileName).ToList();

        return Ok(files);
    }
}