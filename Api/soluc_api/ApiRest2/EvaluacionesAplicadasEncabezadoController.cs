using System.Data;
using System.Web.Http;
using Datos;
using Entidades;

namespace ApiRest2
{
    public class EvaluacionesAplicadasEncabezadoController : ApiController
    {
       [HttpPost]
       [Route("api/AgregarEvaluacionAplicadaEncabezado")]

       public DataTable Agregar(EntidadesEvaluacionesAplicadasEncabezado entidad)
        {
            return DatosEvaluacionesAplicadasEncabezado.Agregar(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerEvaluacionesAplicadasEncabezado")]

        public DataTable ObtenerRegistros(EntidadesEvaluacionesAplicadasEncabezado entidad)
        {
            return DatosEvaluacionesAplicadasEncabezado.ObtenerRegistros(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerDatosEvaluacionAplicadaEncabezado")]

        public DataTable ObtenerDatos(EntidadesEvaluacionesAplicadasEncabezado entidad)
        {
            return DatosEvaluacionesAplicadasEncabezado.ObtenerDatos(entidad);
        }


        [HttpPost]
        [Route("api/EliminarEvaluacionAplicadaEncabezado")]

        public DataTable Eliminar(EntidadesEvaluacionesAplicadasEncabezado entidad)
        {
            return DatosEvaluacionesAplicadasEncabezado.Eliminar(entidad);
        }


        [HttpPost]
        [Route("api/ActualizarEvaluacionAplicadaEncabezado")]

        public DataTable Actualizar(EntidadesEvaluacionesAplicadasEncabezado entidad)
        {
            return DatosEvaluacionesAplicadasEncabezado.Actualizar(entidad);
        }

        
    }
}