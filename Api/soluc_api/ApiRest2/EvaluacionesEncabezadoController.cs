using System.Data;
using System.Web.Http;
using Datos;
using Entidades;

namespace ApiRest2
{
    public class EvaluacionesEncabezadoController : ApiController
    {
       [HttpPost]
       [Route("api/AgregarEvaluacionEncabezado")]

       public DataTable Agregar(EntidadesEvaluacionesEncabezado entidad)
        {
            return DatosEvaluacionesEncabezado.Agregar(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerEvaluacionesEncabezado")]

        public DataTable ObtenerRegistros(EntidadesEvaluacionesEncabezado entidad)
        {
            return DatosEvaluacionesEncabezado.ObtenerRegistros(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerDatosEvaluacionEncabezado")]

        public DataTable ObtenerDatos(EntidadesEvaluacionesEncabezado entidad)
        {
            return DatosEvaluacionesEncabezado.ObtenerDatos(entidad);
        }


        [HttpPost]
        [Route("api/EliminarEvaluacionEncabezado")]

        public DataTable Eliminar(EntidadesEvaluacionesEncabezado entidad)
        {
            return DatosEvaluacionesEncabezado.Eliminar(entidad);
        }


        [HttpPost]
        [Route("api/ActualizarEvaluacionEncabezado")]

        public DataTable Actualizar(EntidadesEvaluacionesEncabezado entidad)
        {
            return DatosEvaluacionesEncabezado.Actualizar(entidad);
        }

        
    }
}