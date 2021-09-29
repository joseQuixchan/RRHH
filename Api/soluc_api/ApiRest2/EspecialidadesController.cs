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
    public class EspecialidadesController : ApiController
    {
       [HttpPost]
       [Route("api/AgregarEspecialidad")]

       public DataTable AgregarEspecialidad(EntidadesEspecialidades entidad)
        {
            return DatosEspecialidades.AgregarEspecialidad(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerEspecialidades")]

        public DataTable ObtenerEspecialidades(EntidadesEspecialidades entidad)
        {
            return DatosEspecialidades.ObtenerEspecialidades(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerDatosEspecialidad")]

        public DataTable ObtenerDatosEspecialidad(EntidadesEspecialidades entidad)
        {
            return DatosEspecialidades.ObtenerDatosEspecialidad(entidad);
        }


        [HttpPost]
        [Route("api/EliminarEspecialidad")]

        public DataTable EliminarEspecialidad(EntidadesEspecialidades entidad)
        {
            return DatosEspecialidades.EliminarEspecialidad(entidad);
        }


        [HttpPost]
        [Route("api/ActualizarEspecialidad")]

        public DataTable ActualizarEspecialidad(EntidadesEspecialidades entidad)
        {
            return DatosEspecialidades.ActualizarEspecialidad(entidad);
        }

        
    }
}