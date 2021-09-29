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
    public class PuestosController : ApiController
    {
       [HttpPost]
       [Route("api/AgregarPuesto")]

       public DataTable AgregarPuesto(EntidadesPuestos entidad)
        {
            return DatosPuestos.AgregarPuesto(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerPuestos")]

        public DataTable ObtenerPuestos(EntidadesPuestos entidad)
        {
            return DatosPuestos.ObtenerPuestos(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerDatosPuesto")]

        public DataTable ObtenerDatosPuesto(EntidadesPuestos entidad)
        {
            return DatosPuestos.ObtenerDatosPuesto(entidad);
        }


        [HttpPost]
        [Route("api/EliminarPuesto")]

        public DataTable EliminarPuesto(EntidadesPuestos entidad)
        {
            return DatosPuestos.EliminarPuesto(entidad);
        }


        [HttpPost]
        [Route("api/ActualizarPuesto")]

        public DataTable ActualizarPuesto(EntidadesPuestos entidad)
        {
            return DatosPuestos.ActualizarPuesto(entidad);
        }

        
    }
}