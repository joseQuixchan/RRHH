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
    public class UsuariosController : ApiController
    {
       [HttpPost]
       [Route("api/AgregarUsuario")]

       public DataTable Agregarusuario(EntidadesUsuarios entidad)
        {
            return DatosUsuarios.AgregarUsuario(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerUsuarios")]

        public DataTable ObtenerUsuarios(EntidadesUsuarios entidad)
        {
            return DatosUsuarios.ObtenerUsuarios(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerDatosUsuario")]

        public DataTable ObtenerDatosUsuario(EntidadesUsuarios entidad)
        {
            return DatosUsuarios.ObtenerDatosUsuario(entidad);
        }


        [HttpPost]
        [Route("api/EliminarUsuario")]

        public DataTable EliminarUsuario(EntidadesUsuarios entidad)
        {
            return DatosUsuarios.EliminarUsuario(entidad);
        }


        [HttpPost]
        [Route("api/ActualizarUsuario")]

        public DataTable ActualizarUsuario(EntidadesUsuarios entidad)
        {
            return DatosUsuarios.ActualizarUsuario(entidad);
        }


        [HttpPost]
        [Route("api/InicioDeSesion")]

        public DataTable InicioDeSesion(EntidadesUsuarios entidad)
        {
            return DatosUsuarios.InicioDeSesion(entidad);
        }


        [HttpPost]
        [Route("api/MenuUsuario")]

        public DataTable MenuUsuario(EntidadesUsuarios entidad)
        {
            return DatosUsuarios.MenuUsuario(entidad);
        }
        
    }
}