using System.Data;
using System.Data.SqlClient;

namespace RMS_Server.Interfaces;

public interface IStoredProcedureService
{
    void ExecuteStoredProcedure(string procedureName, SqlParameter[] parameters);
    DataTable ExecuteStoredProcedureWithResults(string procedureName, SqlParameter[] parameters);
    void ExecuteQuery(string query);
    DataTable ExecuteQueryWithResults(string query);
}