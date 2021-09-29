using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Datos;
using Entidades;

namespace ApiRest2
{
    public class EmpleadosController : ApiController
    {
       [HttpPost]
       [Route("api/AgregarEmpleados")]

       public DataTable Agregarempleados(EntidadesEmpleados entidad)
        {
            return DatosEmpleados.AgregarEmpleados(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerEmpleados")]

        public DataTable ObtenerEmpleados(EntidadesEmpleados entidad)
        {
            return DatosEmpleados.ObtenerEmpleados(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerDatosEmpleado")]

        public DataTable ObtenerDatosEmpleado(EntidadesEmpleados entidad)
        {
            return DatosEmpleados.ObtenerDatosEmpleado(entidad);
        }


        [HttpPost]
        [Route("api/EliminarEmpleados")]

        public DataTable EliminarEmpleados(EntidadesEmpleados entidad)
        {
            return DatosEmpleados.EliminarEmpleados(entidad);
        }


        [HttpPost]
        [Route("api/ActualizarEmpleado")]

        public DataTable ActualizarEmpleado(EntidadesEmpleados entidad)
        {
            return DatosEmpleados.ActualizarEmpleado(entidad);
        }

        
    }
}