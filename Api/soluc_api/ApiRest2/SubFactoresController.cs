using System.Data;
using System.Web.Http;
using Datos;
using Entidades;

namespace ApiRest2
{
    public class SubFactoresController : ApiController
    {
       [HttpPost]
       [Route("api/AgregarSubFactor")]

       public DataTable Agregar(EntidadesSubFactores entidad)
        {
            return DatosSubFactores.Agregar(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerSubFactores")]

        public DataTable ObtenerRegistros(EntidadesSubFactores entidad)
        {
            return DatosSubFactores.ObtenerRegistros(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerDatosSubFactor")]

        public DataTable ObtenerDatos(EntidadesSubFactores entidad)
        {
            return DatosSubFactores.ObtenerDatos(entidad);
        }


        [HttpPost]
        [Route("api/EliminarSubFactor")]

        public DataTable Eliminar(EntidadesSubFactores entidad)
        {
            return DatosSubFactores.Eliminar(entidad);
        }


        [HttpPost]
        [Route("api/ActualizarSubFactor")]

        public DataTable Actualizar(EntidadesSubFactores entidad)
        {
            return DatosSubFactores.Actualizar(entidad);
        }

        
    }
}