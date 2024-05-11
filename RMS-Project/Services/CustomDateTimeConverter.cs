using System.Globalization;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace RMS_Project.Services;

public class CustomDateTimeConverter : JsonConverter<DateTime>
{
    private readonly string _dateFormat;

    public CustomDateTimeConverter(string dateFormat)
    {
        _dateFormat = dateFormat;
    }

    public override DateTime Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        if (reader.TokenType == JsonTokenType.Number)
        {
            // Assuming the number is a Unix timestamp
            var unixTime = reader.GetInt64();
            return DateTimeOffset.FromUnixTimeSeconds(unixTime).DateTime;
        }
        else if (reader.TokenType == JsonTokenType.String)
        {
            var dateString = reader.GetString();
            return DateTime.ParseExact(dateString, _dateFormat, CultureInfo.InvariantCulture);
        }

        throw new JsonException("Unexpected token type for DateTime conversion.");
    }

    public override void Write(Utf8JsonWriter writer, DateTime value, JsonSerializerOptions options)
    {
        writer.WriteStringValue(value.ToString(_dateFormat));
    }
}