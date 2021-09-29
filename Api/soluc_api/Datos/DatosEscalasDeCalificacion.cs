using Entidades;
using System.Data;
using System.Data.SqlClient;

namespace Datos
{
    public class DatosEscalasDeCalificacion
    {
        private static readonly Funciones Funciones = new Funciones();
        private static DataTable DT = new DataTable();
        private static int Estado = 0;


        public static DataTable Agregar(EntidadesEscalasDeCalificacion Entidad)
        {
            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();
            // 0 = expirado, 1 = vigente

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPAgregarEscalaDeCalificacion");
                Comando.Parameters.AddWithValue("@_TxtEscalaDeCalificacion", Entidad.TxtEscalaDeCalificacion);
                Comando.Parameters.AddWithValue("@_DbPunteo", Entidad.DbPunteo);
                Comando.Parameters.AddWithValue("@_TxtDescripcion", Entidad.TxtDescripcion);
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




        public static DataTable ObtenerRegistros(EntidadesEscalasDeCalificacion Entidad)
        {
            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPObtenerEscalasDeCalificacion");
                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;
        }




        public static DataTable ObtenerDatos(EntidadesEscalasDeCalificacion Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPObtenerDatosEscalaDeCalificacion");
                Comando.Parameters.AddWithValue("@_IdRegistro", Entidad.IdEscalaDeCalificacion);

                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;
        }




        public static DataTable Eliminar(EntidadesEscalasDeCalificacion Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {

                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPEliminarEscalaDeCalificacion");
                Comando.Parameters.AddWithValue("@_IdRegistro", Entidad.IdEscalaDeCalificacion);

                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;


        }



        public static DataTable Actualizar(EntidadesEscalasDeCalificacion Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {

                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPActualizarEscalaDeCalificacion");
                Comando.Parameters.AddWithValue("@_IdRegistro", Entidad.IdEscalaDeCalificacion);
                Comando.Parameters.AddWithValue("@_TxtEscalaDeCalificacion", Entidad.TxtEscalaDeCalificacion);
                Comando.Parameters.AddWithValue("@_DbPunteo", Entidad.DbPunteo);
                Comando.Parameters.AddWithValue("@_TxtDescripcion", Entidad.TxtDescripcion);

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
