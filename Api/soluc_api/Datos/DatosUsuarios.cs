using Entidades;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Datos
{
    public class DatosUsuarios
    {
        private static readonly Funciones Funciones = new Funciones();
        private static readonly int VigenciaEnMinutos = 30;
        private static DataTable DT = new DataTable();
        private static int Estado = 0;


        public static DataTable AgregarUsuario(Entidades.EntidadesUsuarios Entidad)
        {
            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);

            // 0 = expirado, 1 = vigente

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("Sesion.SPAgregarUsuario");
                Comando.Parameters.AddWithValue("@_TxtNombres", Entidad.TxtNombres);
                Comando.Parameters.AddWithValue("@_TxtApellidos", Entidad.TxtApellidos);
                Comando.Parameters.AddWithValue("@_TxtDireccion", Entidad.TxtDireccion);
                Comando.Parameters.AddWithValue("@_TxtEmail", Entidad.TxtEmail);
                Comando.Parameters.AddWithValue("@_TxtPassword", Funciones.SeguridadSHA512(Entidad.TxtPassword));
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


        public static DataTable ObtenerUsuarios(EntidadesUsuarios Entidad)
        {
            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("Sesion.SPObtenerUsuarios");
                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }

            return DT;
        }

        public static DataTable ObtenerDatosUsuario(EntidadesUsuarios Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("Sesion.SPObtenerDatosUsuario");
                Comando.Parameters.AddWithValue("@_IdUsuario", Entidad.IdUsuario);

                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }

            return DT;
        }




        public static DataTable EliminarUsuario(EntidadesUsuarios Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);

            if (Estado == 1)
            {

                SqlCommand Comando = Conexion.CrearComandoProc("Sesion.SPEliminarUsuario");
                Comando.Parameters.AddWithValue("@_IdUsuario", Entidad.IdUsuario);

                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;


        }



        public static DataTable ActualizarUsuario(EntidadesUsuarios Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);

            if (Estado == 1)
            {

                SqlCommand Comando = Conexion.CrearComandoProc("Sesion.SPActualizarUsuario");
                Comando.Parameters.AddWithValue("@_IdUsuario", Entidad.IdUsuario);
                Comando.Parameters.AddWithValue("@_TxtNombres", Entidad.TxtNombres);
                Comando.Parameters.AddWithValue("@_TxtApellidos", Entidad.TxtApellidos);
                Comando.Parameters.AddWithValue("@_TxtDireccion", Entidad.TxtDireccion);
                Comando.Parameters.AddWithValue("@_TxtEmail", Entidad.TxtEmail);
                Comando.Parameters.AddWithValue("@_TxtPassword", Funciones.SeguridadSHA512(Entidad.TxtPassword));

                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;

        }

        public static DataTable InicioDeSesion(EntidadesUsuarios Entidad)
        {
            DataTable DT = new DataTable();

            SqlCommand Comando = Conexion.CrearComandoProc("Sesion.SPInicioDeSesion");
            Comando.Parameters.AddWithValue("@_TxtEmail", Entidad.TxtEmail);
            Comando.Parameters.AddWithValue("@_TxtPassword", Funciones.SeguridadSHA512(Entidad.TxtPassword));
            Comando.Parameters.AddWithValue("@_TxtToken", Funciones.GenerarTokenDeSesion());
            Comando.Parameters.AddWithValue("@_VigenciaEnMinutos", VigenciaEnMinutos);

            return Conexion.EjecutarComandoSelect(Comando);
        }

       


        //OBTIENE LOS ENLACES O MENUS DE OPCIONES A LAS QUE TENDRÁ ACCESO EL USUARIO
        public static DataTable MenuUsuario(EntidadesUsuarios Entidad)
        {
            DataTable DT = new DataTable();

            SqlCommand Comando = Conexion.CrearComandoProc("Sesion.SPMenuUsuario");
            Comando.Parameters.AddWithValue("@_TxtToken", Entidad.TxtToken);
            Comando.Parameters.AddWithValue("@_IdModulo", Entidad.IdModulo);// 1 = Evaluacion del desempeño

            return Conexion.EjecutarComandoSelect(Comando);
        }


    }
}
