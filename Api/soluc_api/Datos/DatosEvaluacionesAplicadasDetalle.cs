using Entidades;
using System.Data;
using System.Data.SqlClient;

namespace Datos
{
    public class DatosEvaluacionesAplicadasDetalle
    {
        private static readonly Funciones Funciones = new Funciones();
        private static DataTable DT = new DataTable();
        private static int Estado = 0;


        public static DataTable Agregar(EntidadesEvaluacionesAplicadasDetalle Entidad)
        {
            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();
            // 0 = expirado, 1 = vigente

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPAgregarEvaluacionAplicadaDetalle");
                Comando.Parameters.AddWithValue("@_IdEvaluacionAplicadaEncabezado", Entidad.IdEvaluacionAplicadaEncabezado);
                Comando.Parameters.AddWithValue("@_IdEvaluacionDetalle", Entidad.IdEvaluacionDetalle);
                Comando.Parameters.AddWithValue("@_IdEscalaDeCalificacion", Entidad.IdEscalaDeCalificacion);
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




        public static DataTable ObtenerRegistros(EntidadesEvaluacionesAplicadasDetalle Entidad)
        {
            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPObtenerEvaluacionesAplicadasDetalle");
                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;
        }




        public static DataTable ObtenerDatos(EntidadesEvaluacionesAplicadasDetalle Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPObtenerDatosEvaluacionAplicadasDetalle");
                Comando.Parameters.AddWithValue("@_IdRegistro", Entidad.IdEvaluacionAplicadaDetalle);

                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;
        }




        public static DataTable Eliminar(EntidadesEvaluacionesAplicadasDetalle Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {

                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPEliminarEvaluacionAplicadaDetalle");
                Comando.Parameters.AddWithValue("@_IdRegistro", Entidad.IdEvaluacionAplicadaDetalle);

                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;


        }



        public static DataTable Actualizar(EntidadesEvaluacionesAplicadasDetalle Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {

                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPActualizarEvaluacionAplicadaDetalle");
                Comando.Parameters.AddWithValue("@_IdRegistro", Entidad.IdEvaluacionAplicadaDetalle);
                Comando.Parameters.AddWithValue("@_IdEvaluacionAplicadaEncabezado", Entidad.IdEvaluacionAplicadaEncabezado);
                Comando.Parameters.AddWithValue("@_IdEvaluacionDetalle", Entidad.IdEvaluacionDetalle);
                Comando.Parameters.AddWithValue("@_IdEscalaDeCalificacion", Entidad.IdEscalaDeCalificacion);

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
