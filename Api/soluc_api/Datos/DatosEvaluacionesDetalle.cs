using Entidades;
using System.Data;
using System.Data.SqlClient;

namespace Datos
{
    public class DatosEvaluacionesDetalle
    {
        private static readonly Funciones Funciones = new Funciones();
        private static DataTable DT = new DataTable();
        private static int Estado = 0;


        public static DataTable Agregar(EntidadesEvaluacionesDetalle Entidad)
        {
            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();
            // 0 = expirado, 1 = vigente

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPAgregarEvaluacionDetalle");
                Comando.Parameters.AddWithValue("@_IdEvaluacionEncabezado", Entidad.IdEvaluacionEncabezado);
                Comando.Parameters.AddWithValue("@_IdFactor", Entidad.IdFactor);
                Comando.Parameters.AddWithValue("@_IdSubFactor", Entidad.IdSubFactor);
                Comando.Parameters.AddWithValue("@_TxtToken", Entidad.TxtToken);

                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;
        }




        public static DataTable ObtenerRegistros(EntidadesEvaluacionesDetalle Entidad)
        {
            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPObtenerEvaluacionesDetalle");
                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;
        }




        public static DataTable ObtenerDatos(EntidadesEvaluacionesDetalle Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPObtenerDatosEvaluacionDetalle");
                Comando.Parameters.AddWithValue("@_IdRegistro", Entidad.IdEvaluacionDetalle);

                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;
        }




        public static DataTable Eliminar(EntidadesEvaluacionesDetalle Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {

                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPEliminarEvaluacionDetalle");
                Comando.Parameters.AddWithValue("@_IdRegistro", Entidad.IdEvaluacionDetalle);

                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;


        }



        public static DataTable Actualizar(EntidadesEvaluacionesDetalle Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {

                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPActualizarEvaluacionDetalle");
                Comando.Parameters.AddWithValue("@_IdRegistro", Entidad.IdEvaluacionDetalle);
                Comando.Parameters.AddWithValue("@_IdEvaluacionEncabezado", Entidad.IdEvaluacionEncabezado);
                Comando.Parameters.AddWithValue("@_IdFactor", Entidad.IdFactor);
                Comando.Parameters.AddWithValue("@_IdSubFactor", Entidad.IdSubFactor);

                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;

        }
    }
}
