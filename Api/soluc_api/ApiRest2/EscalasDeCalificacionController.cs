using System.Data;
using System.Web.Http;
using Datos;
using Entidades;

namespace ApiRest2
{
    public class EscalasDeCalificacionController : ApiController
    {
       [HttpPost]
       [Route("api/AgregarEscalaDeCalificacion")]

       public DataTable Agregar(EntidadesEscalasDeCalificacion entidad)
        {
            return DatosEscalasDeCalificacion.Agregar(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerEscalasDeCalificacion")]

        public DataTable ObtenerRegistros(EntidadesEscalasDeCalificacion entidad)
        {
            return DatosEscalasDeCalificacion.ObtenerRegistros(entidad);
        }


        [HttpPost]
        [Route("api/ObtenerDatosEscalaDeCalificacion")]

        public DataTable ObtenerDatos(EntidadesEscalasDeCalificacion entidad)
        {
            return DatosEscalasDeCalificacion.ObtenerDatos(entidad);
        }


        [HttpPost]
        [Route("api/EliminarEscalaDeCalificacion")]

        public DataTable Eliminar(EntidadesEscalasDeCalificacion entidad)
        {
            return DatosEscalasDeCalificacion.Eliminar(entidad);
        }


        [HttpPost]
        [Route("api/ActualizarEscalaDeCalificacion")]

        public DataTable Actualizar(EntidadesEscalasDeCalificacion entidad)
        {
            return DatosEscalasDeCalificacion.Actualizar(entidad);
        }

        
    }
}