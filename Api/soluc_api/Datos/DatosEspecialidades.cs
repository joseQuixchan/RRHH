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
    public class DatosEspecialidades
    {
        private static readonly Funciones Funciones = new Funciones();
        private static DataTable DT = new DataTable();
        private static int Estado = 0;


        public static DataTable AgregarEspecialidad(EntidadesEspecialidades Entidad)
        {
            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();
            // 0 = expirado, 1 = vigente

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPAgregarEspecialidad");
                Comando.Parameters.AddWithValue("@_TxtEspecialidad", Entidad.TxtEspecialidad);
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




        public static DataTable ObtenerEspecialidades(EntidadesEspecialidades Entidad)
        {
            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPObtenerEspecialidades");
                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;
        }




        public static DataTable ObtenerDatosEspecialidad(EntidadesEspecialidades Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPObtenerDatosEspecialidad");
                Comando.Parameters.AddWithValue("@_IdRegistro", Entidad.IdEspecialidad);

                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;
        }




        public static DataTable EliminarEspecialidad(EntidadesEspecialidades Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {

                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPEliminarEspecialidad");
                Comando.Parameters.AddWithValue("@_IdEspecialidad", Entidad.IdEspecialidad);

                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;


        }



        public static DataTable ActualizarEspecialidad(EntidadesEspecialidades Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {

                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPActualizarEspecialidad");
                Comando.Parameters.AddWithValue("@_IdEspecialidad", Entidad.IdEspecialidad);
                Comando.Parameters.AddWithValue("@_TxtEspecialidad", Entidad.TxtEspecialidad);

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
