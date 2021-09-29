using Entidades;
using System.Data;
using System.Data.SqlClient;

namespace Datos
{
    public class DatosEvaluacionesEncabezado
    {
        private static readonly Funciones Funciones = new Funciones();
        private static DataTable DT = new DataTable();
        private static int Estado = 0;


        public static DataTable Agregar(EntidadesEvaluacionesEncabezado Entidad)
        {
            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();
            // 0 = expirado, 1 = vigente

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPAgregarEvaluacionEncabezado");
                Comando.Parameters.AddWithValue("@_IdTipoDeEvaluacion", Entidad.IdTipoDeEvaluacion);
                Comando.Parameters.AddWithValue("@_Anio", Entidad.anio);
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




        public static DataTable ObtenerRegistros(EntidadesEvaluacionesEncabezado Entidad)
        {
            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPObtenerEvaluacionesEncabezado");
                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;
        }




        public static DataTable ObtenerDatos(EntidadesEvaluacionesEncabezado Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPObtenerDatosEvaluacionEncabezado");
                Comando.Parameters.AddWithValue("@_IdRegistro", Entidad.IdEvaluacionEncabezado);

                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;
        }




        public static DataTable Eliminar(EntidadesEvaluacionesEncabezado Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {

                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPEliminarEvaluacionEncabezado");
                Comando.Parameters.AddWithValue("@_IdRegistro", Entidad.IdEvaluacionEncabezado);

                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;


        }



        public static DataTable Actualizar(EntidadesEvaluacionesEncabezado Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {

                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPActualizarEvaluacionEncabezado");
                Comando.Parameters.AddWithValue("@_IdRegistro", Entidad.IdEvaluacionEncabezado);
                Comando.Parameters.AddWithValue("@_IdTipoDeEvaluacion", Entidad.IdTipoDeEvaluacion);
                Comando.Parameters.AddWithValue("@_Anio", Entidad.anio);


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
