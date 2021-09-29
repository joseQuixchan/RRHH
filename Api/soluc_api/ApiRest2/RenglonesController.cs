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
    public class RenglonesController : ApiController
    {
       [HttpPost]
       [Route("api/AgregarRenglon")]

       public DataTable AgregarRenglon(EntidadesRenglones entidad)
        {
            return DatosRenglones.AgregarRenglon(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerRenglones")]

        public DataTable ObtenerRenglones(EntidadesRenglones entidad)
        {
            return DatosRenglones.ObtenerRenglones(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerDatosRenglon")]

        public DataTable ObtenerDatosPuesto(EntidadesRenglones entidad)
        {
            return DatosRenglones.ObtenerDatosRenglon(entidad);
        }


        [HttpPost]
        [Route("api/EliminarRenglon")]

        public DataTable EliminarRenglon(EntidadesRenglones entidad)
        {
            return DatosRenglones.EliminarRenglon(entidad);
        }


        [HttpPost]
        [Route("api/ActualizarRenglon")]

        public DataTable ActualizarRenglon(EntidadesRenglones entidad)
        {
            return DatosRenglones.ActualizarRenglon(entidad);
        }

        
    }
}