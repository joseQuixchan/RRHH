using System.Data;
using System.Web.Http;
using Datos;
using Entidades;

namespace ApiRest2
{
    public class TiposDeEvaluacionesController : ApiController
    {
       [HttpPost]
       [Route("api/AgregarTipoDeEvaluacion")]

       public DataTable Agregar(EntidadesTiposDeEvaluaciones entidad)
        {
            return DatosTiposDeEvaluaciones.Agregar(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerTiposDeEvaluaciones")]

        public DataTable ObtenerRegistros(EntidadesTiposDeEvaluaciones entidad)
        {
            return DatosTiposDeEvaluaciones.ObtenerRegistros(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerDatosTipoDeEvaluacion")]

        public DataTable ObtenerDatos(EntidadesTiposDeEvaluaciones entidad)
        {
            return DatosTiposDeEvaluaciones.ObtenerDatos(entidad);
        }


        [HttpPost]
        [Route("api/EliminarTipoDeEvaluacion")]

        public DataTable Eliminar(EntidadesTiposDeEvaluaciones entidad)
        {
            return DatosTiposDeEvaluaciones.Eliminar(entidad);
        }


        [HttpPost]
        [Route("api/ActualizarTipoDeEvaluacion")]

        public DataTable Actualizar(EntidadesTiposDeEvaluaciones entidad)
        {
            return DatosTiposDeEvaluaciones.Actualizar(entidad);
        }

        
    }
}