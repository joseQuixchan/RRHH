using Entidades;
using System.Data;
using System.Data.SqlClient;

namespace Datos
{
    public class DatosEvaluacionesAplicadasEncabezado
    {
        private static readonly Funciones Funciones = new Funciones();
        private static DataTable DT = new DataTable();
        private static int Estado = 0;


        public static DataTable Agregar(EntidadesEvaluacionesAplicadasEncabezado Entidad)
        {
            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();
            // 0 = expirado, 1 = vigente

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPAgregarEvaluacionAplicadaEncabezado");
                Comando.Parameters.AddWithValue("@_IdInstitucion", Entidad.IdInstitucion);
                Comando.Parameters.AddWithValue("@_IdEvaluacionEncabezado", Entidad.IdEvaluacionEncabezado);
                Comando.Parameters.AddWithValue("@_IdEmpleado", Entidad.IdEmpleado);
                Comando.Parameters.AddWithValue("@_FechaDeAplicacion", Entidad.FechaDeAplicacion);
                Comando.Parameters.AddWithValue("@_FechaInicial", Entidad.FechaInicial);
                Comando.Parameters.AddWithValue("@_FechaFinal", Entidad.FechaFinal);
                Comando.Parameters.AddWithValue("@_DbPunteoTotal", Entidad.DbPunteoTotal);
                Comando.Parameters.AddWithValue("@_TxtObservacionesDeJefe", Entidad.TxtObservacionesDeJefe);
                Comando.Parameters.AddWithValue("@_TxtObservacionesDeEmpleado", Entidad.TxtObservacionesDeEmpleado);
                Comando.Parameters.AddWithValue("@_IntNecesitaPlanDeMejora", Entidad.IntNecesitaPlanDeMejora);
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




        public static DataTable ObtenerRegistros(EntidadesEvaluacionesAplicadasEncabezado Entidad)
        {
            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPObtenerEvaluacionesAplicadasEncabezado");
                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;
        }




        public static DataTable ObtenerDatos(EntidadesEvaluacionesAplicadasEncabezado Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPObtenerDatosEvaluacionAplicadasEncabezado");
                Comando.Parameters.AddWithValue("@_IdRegistro", Entidad.IdEvaluacionAplicadaEncabezado);

                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;
        }




        public static DataTable Eliminar(EntidadesEvaluacionesAplicadasEncabezado Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {

                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPEliminarEvaluacionAplicadaEncabezado");
                Comando.Parameters.AddWithValue("@_IdRegistro", Entidad.IdEvaluacionAplicadaEncabezado);

                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;


        }



        public static DataTable Actualizar(EntidadesEvaluacionesAplicadasEncabezado Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {

                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPActualizarEvaluacionAplicadaEncabezado");
                Comando.Parameters.AddWithValue("@_IdRegistro", Entidad.IdEvaluacionAplicadaEncabezado);
                Comando.Parameters.AddWithValue("@_IdInstitucion", Entidad.IdInstitucion);
                Comando.Parameters.AddWithValue("@_IdEvaluacionEncabezado", Entidad.IdEvaluacionEncabezado);
                Comando.Parameters.AddWithValue("@_IdEmpleado", Entidad.IdEmpleado);
                Comando.Parameters.AddWithValue("@_FechaDeAplicacion", Entidad.FechaDeAplicacion);
                Comando.Parameters.AddWithValue("@_FechaInicial", Entidad.FechaInicial);
                Comando.Parameters.AddWithValue("@_FechaFinal", Entidad.FechaFinal);
                Comando.Parameters.AddWithValue("@_DbPunteoTotal", Entidad.DbPunteoTotal);
                Comando.Parameters.AddWithValue("@_TxtObservacionesDeJefe", Entidad.TxtObservacionesDeJefe);
                Comando.Parameters.AddWithValue("@_TxtObservacionesDeEmpleado", Entidad.TxtObservacionesDeEmpleado);
                Comando.Parameters.AddWithValue("@_IntNecesitaPlanDeMejora", Entidad.IntNecesitaPlanDeMejora);


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
