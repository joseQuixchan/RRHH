using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Configuration;

namespace Datos
{
    public class Conexion
    {
        private static string Usuario = WebConfigurationManager.AppSettings["Usuario"].ToString();
        private static string Password = WebConfigurationManager.AppSettings["Password"].ToString();
        private static string Servidor = WebConfigurationManager.AppSettings["Servidor"].ToString();
        private static string DB = WebConfigurationManager.AppSettings["DB"].ToString();

        public static string CadenaConexionSQL()
        {
            return "Persist Security Info = false; User ID = '" + Usuario
            + "'; Password = '" + Password
            + "'; Initial Catalog = '" + DB
            + "'; Server = '" + Servidor + "'";
        }


        //EJECUTAR PROCEDIMIENTO ALMACENADO PASANDOLO COMO PARAMETRO         
        public static SqlCommand CrearComandoProc(string SP)         
        {             
            string CadenaConexion = Conexion.CadenaConexionSQL();             
            SqlConnection MiConexion = new SqlConnection(CadenaConexion);             
            SqlCommand Comando = new SqlCommand(SP, MiConexion);             
            Comando.CommandType = CommandType.StoredProcedure;             
            return Comando;         
        }          
        

        /*          EjecutarComandoSelect          */         
        public static DataTable EjecutarComandoSelect(SqlCommand Comando)         
        {             
            DataTable DT = new DataTable();             
            try             
            {                 
                Comando.Connection.Open();                 
                SqlDataAdapter adaptador = new SqlDataAdapter();                 
                adaptador.SelectCommand = Comando;                 
                adaptador.Fill(DT);             
            }             
            catch (Exception ex)             
            {                 
                throw ex;             
            }             
            finally             
            {                 
                Comando.Connection.Dispose();
                Comando.Connection.Dispose();
                Comando.Connection.Close();
            }
            return DT;
        }

    }
}
