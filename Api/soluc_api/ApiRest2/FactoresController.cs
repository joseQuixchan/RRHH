using System.Data;
using System.Web.Http;
using Datos;
using Entidades;

namespace ApiRest2
{
    public class FactoresController : ApiController
    {
       [HttpPost]
       [Route("api/AgregarFactor")]

       public DataTable Agregar(EntidadesFactores entidad)
        {
            return DatosFactores.Agregar(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerFactores")]

        public DataTable ObtenerRegistros(EntidadesFactores entidad)
        {
            return DatosFactores.ObtenerRegistros(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerDatosFactor")]

        public DataTable ObtenerDatos(EntidadesFactores entidad)
        {
            return DatosFactores.ObtenerDatos(entidad);
        }


        [HttpPost]
        [Route("api/EliminarFactor")]

        public DataTable Eliminar(EntidadesFactores entidad)
        {
            return DatosFactores.Eliminar(entidad);
        }


        [HttpPost]
        [Route("api/ActualizarFactor")]

        public DataTable Actualizar(EntidadesFactores entidad)
        {
            return DatosFactores.Actualizar(entidad);
        }

        
    }
}