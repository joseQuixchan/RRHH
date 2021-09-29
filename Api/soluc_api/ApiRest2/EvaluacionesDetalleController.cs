using System.Data;
using System.Web.Http;
using Datos;
using Entidades;

namespace ApiRest2
{
    public class EvaluacionesDetalleController : ApiController
    {
       [HttpPost]
       [Route("api/AgregarEvaluacionDetalle")]

       public DataTable Agregar(EntidadesEvaluacionesDetalle entidad)
        {
            return DatosEvaluacionesDetalle.Agregar(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerEvaluacionesDetalle")]

        public DataTable ObtenerRegistros(EntidadesEvaluacionesDetalle entidad)
        {
            return DatosEvaluacionesDetalle.ObtenerRegistros(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerDatosEvaluacionDetalle")]

        public DataTable ObtenerDatos(EntidadesEvaluacionesDetalle entidad)
        {
            return DatosEvaluacionesDetalle.ObtenerDatos(entidad);
        }


        [HttpPost]
        [Route("api/EliminarEvaluacionDetalle")]

        public DataTable Eliminar(EntidadesEvaluacionesDetalle entidad)
        {
            return DatosEvaluacionesDetalle.Eliminar(entidad);
        }


        [HttpPost]
        [Route("api/ActualizarEvaluacionDetalle")]

        public DataTable Actualizar(EntidadesEvaluacionesDetalle entidad)
        {
            return DatosEvaluacionesDetalle.Actualizar(entidad);
        }

        
    }
}