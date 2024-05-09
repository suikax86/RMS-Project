using System.Data;
using System.Data.SqlClient;
using RMS_Server.Interfaces;

namespace RMS_Server.Services;

public class StoredProcedureService(IDbConnection connection) : IStoredProcedureService
{
    private readonly IDbConnection _connection = connection ?? throw new ArgumentNullException(nameof(connection));

    public void ExecuteStoredProcedure(string procedureName, SqlParameter[] parameters)
    {
        using var command = _connection.CreateCommand();
        command.CommandType = CommandType.StoredProcedure;
        command.CommandText = procedureName;
           
        if (parameters != null)
        {
            foreach (var parameter in parameters)
            {
                command.Parameters.Add(parameter);
            }
        }

        _connection.Open();
        command.ExecuteNonQuery();
        _connection.Close();
    }

    public DataTable ExecuteStoredProcedureWithResults(string procedureName, SqlParameter[] parameters)
    {
        using var command = _connection.CreateCommand();
        command.CommandType = CommandType.StoredProcedure;
        command.CommandText = procedureName;
        if (parameters != null)
        {
            foreach (var parameter in parameters)
            {
                command.Parameters.Add(parameter);
            }
        }

        _connection.Open();
        var reader = command.ExecuteReader();
        var result = new DataTable();
        result.Load(reader);
        _connection.Close();
        return result;
    }

}