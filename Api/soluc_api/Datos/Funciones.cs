using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace Datos
{
    public class Funciones
    {
        public string lblStatus = "";
        private string CodigoDeSeguridad = "j@3!";
        private static DataTable DT = new DataTable();

        public string SeguridadSHA512(string Pass)
        {
            System.Security.Cryptography.SHA512Managed HashTool = new System.Security.Cryptography.SHA512Managed();
            Byte[] HashByte = Encoding.UTF8.GetBytes(string.Concat(Pass, CodigoDeSeguridad));
            Byte[] EncryptedByte = HashTool.ComputeHash(HashByte);
            HashTool.Clear();

            return Convert.ToBase64String(EncryptedByte);
        }

        public string GenerarTokenDeSesion()
        {
            Random Rnd = new Random();
            int Aleatorio = Rnd.Next(1, 999999);

            string Hora = DateTime.Now.ToString("hh:mm:ss");
            string Fecha = DateTime.Now.ToString("dd/MM/yyyy");

            string TxtToken = SeguridadSHA512(Fecha + Hora + Aleatorio);

            TxtToken = Regex.Replace(TxtToken, @"[^0-9A-Za-z]", "", RegexOptions.None);
            
            return TxtToken;
        }


        public static int ObtenerEstadoToken(string TxtToken)
        {

            SqlCommand Comando = Conexion.CrearComandoProc("Sesion.SPObtenerEstadoToken");
            Comando.Parameters.AddWithValue("@_TxtToken", TxtToken);

            DT.Reset();
            DT.Clear();

            // 0 = expirado, 1 = vigente
            DT = Conexion.EjecutarComandoSelect(Comando);
            return Convert.ToInt32(DT.Rows[0][0].ToString());
        }


        //AGREGAR EL ESTADO DEL TOKEN A CADA DATATABLE O SET DE DATOS
        public static DataTable AgregarEstadoToken(DataTable DT, String Estado)
        {
            if (DT.Rows.Count > 0)
            {
                DT.Columns.Add("EstadoToken", typeof(string), Estado).SetOrdinal(0);
            }
            else
            {
                DT.Reset();
                DT.Clear();

                try
                {
                    DataColumn Col = new DataColumn();
                    Col.ColumnName = "EstadoToken";
                    DT.Columns.Add(Col);

                    DataRow Fila = DT.NewRow();
                    Fila["EstadoToken"] = Estado;
                    DT.Rows.Add(Fila);
                }
                catch
                {
                    DataRow Fila = DT.NewRow();
                    Fila["EstadoToken"] = Estado;
                    DT.Rows.Add(Fila);
                }
            }

            return DT;
        }


    }
}
