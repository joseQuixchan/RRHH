using System.Data;
using System.Web.Http;
using Datos;
using Entidades;

namespace ApiRest2
{
    public class EvaluacionesAplicadasDetalleController : ApiController
    {
       [HttpPost]
       [Route("api/AgregarEvaluacionAplicadaDetalle")]

       public DataTable Agregar(EntidadesEvaluacionesAplicadasDetalle entidad)
        {
            return DatosEvaluacionesAplicadasDetalle.Agregar(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerEvaluacionesAplicadasDetalle")]

        public DataTable ObtenerRegistros(EntidadesEvaluacionesAplicadasDetalle entidad)
        {
            return DatosEvaluacionesAplicadasDetalle.ObtenerRegistros(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerDatosEvaluacionAplicadaDetalle")]

        public DataTable ObtenerDatos(EntidadesEvaluacionesAplicadasDetalle entidad)
        {
            return DatosEvaluacionesAplicadasDetalle.ObtenerDatos(entidad);
        }


        [HttpPost]
        [Route("api/EliminarEvaluacionAplicadaDetalle")]

        public DataTable Eliminar(EntidadesEvaluacionesAplicadasDetalle entidad)
        {
            return DatosEvaluacionesAplicadasDetalle.Eliminar(entidad);
        }


        [HttpPost]
        [Route("api/ActualizarEvaluacionAplicadaDetalle")]

        public DataTable Actualizar(EntidadesEvaluacionesAplicadasDetalle entidad)
        {
            return DatosEvaluacionesAplicadasDetalle.Actualizar(entidad);
        }

        
    }
}