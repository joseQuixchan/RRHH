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
    public class ServiciosController : ApiController
    {
       [HttpPost]
       [Route("api/AgregarServicio")]

       public DataTable AgregarServicio(EntidadesServicios entidad)
        {
            return DatosServicios.AgregarServicio(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerServicios")]

        public DataTable ObtenerServicios(EntidadesServicios entidad)
        {
            return DatosServicios.ObtenerServicios(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerDatosServicio")]

        public DataTable ObtenerDatosServicio(EntidadesServicios entidad)
        {
            return DatosServicios.ObtenerDatosServicio(entidad);
        }


        [HttpPost]
        [Route("api/EliminarServicio")]

        public DataTable EliminarServicio(EntidadesServicios entidad)
        {
            return DatosServicios.EliminarServicio(entidad);
        }


        [HttpPost]
        [Route("api/ActualizarServicio")]

        public DataTable ActualizarRenglon(EntidadesServicios entidad)
        {
            return DatosServicios.ActualizarServicio(entidad);
        }

        
    }
}