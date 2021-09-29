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
    public class DatosEmpleados
    {
        private static readonly Funciones Funciones = new Funciones();
        private static DataTable DT = new DataTable();
        private static int Estado = 0;


        public static DataTable AgregarEmpleados(EntidadesEmpleados Entidad)
        {
            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();
            // 0 = expirado, 1 = vigente

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPAgregarEmpleados");
                Comando.Parameters.AddWithValue("@_TxtNit", Entidad.TxtNit);
                Comando.Parameters.AddWithValue("@_TxtDpi", Entidad.TxtDpi);
                Comando.Parameters.AddWithValue("@_TxtNombres", Entidad.TxtNombres);
                Comando.Parameters.AddWithValue("@_TxtApellidos", Entidad.TxtApellidos);
                Comando.Parameters.AddWithValue("@_IdPuesto", Entidad.IdPuesto);
                Comando.Parameters.AddWithValue("@_IdEspecialidad", Entidad.IdEspecialidad);
                Comando.Parameters.AddWithValue("@_IdServicio", Entidad.IdServicio);
                Comando.Parameters.AddWithValue("@_IdRenglon", Entidad.IdRenglon);
                Comando.Parameters.AddWithValue("@_IdInstitucion", Entidad.IdInstitucion);
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




        public static DataTable ObtenerEmpleados(EntidadesEmpleados Entidad)
        {
            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPObtenerEmpleados");
                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;
        }




        public static DataTable ObtenerDatosEmpleado(EntidadesEmpleados Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {
                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPObtenerDatosEmpleado");
                Comando.Parameters.AddWithValue("@_IdRegistro", Entidad.IdEmpleado);

                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;
        }




        public static DataTable EliminarEmpleados(EntidadesEmpleados Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {

                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPEliminarEmpleados");
                Comando.Parameters.AddWithValue("@_IdRegistro", Entidad.IdEmpleado);

                DT = Conexion.EjecutarComandoSelect(Comando);
                DT = Funciones.AgregarEstadoToken(DT, Estado.ToString());
            }
            else
            {
                DT = Funciones.AgregarEstadoToken(DT, "0");
            }

            return DT;


        }



        public static DataTable ActualizarEmpleado(EntidadesEmpleados Entidad)
        {

            Estado = Funciones.ObtenerEstadoToken(Entidad.TxtToken);
            DT.Clear();

            if (Estado == 1)
            {

                SqlCommand Comando = Conexion.CrearComandoProc("RRHH.SPActualizarEmpleado");
                Comando.Parameters.AddWithValue("@_IdRegistro", Entidad.IdEmpleado);
                Comando.Parameters.AddWithValue("@_TxtNit", Entidad.TxtNit);
                Comando.Parameters.AddWithValue("@_TxtDpi", Entidad.TxtDpi);
                Comando.Parameters.AddWithValue("@_TxtNombres", Entidad.TxtNombres);
                Comando.Parameters.AddWithValue("@_TxtApellidos", Entidad.TxtApellidos);
                Comando.Parameters.AddWithValue("@_IdPuesto", Entidad.IdPuesto);
                Comando.Parameters.AddWithValue("@_IdEspecialidad", Entidad.IdEspecialidad);
                Comando.Parameters.AddWithValue("@_IdServicio", Entidad.IdServicio);
                Comando.Parameters.AddWithValue("@_IdRenglon", Entidad.IdRenglon);
                Comando.Parameters.AddWithValue("@_IdInstitucion", Entidad.IdInstitucion);

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
