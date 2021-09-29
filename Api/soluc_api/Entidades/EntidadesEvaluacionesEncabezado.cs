using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entidades
{
    public class EntidadesEvaluacionesEncabezado: EntidadTokens
    {
        public int IdEvaluacionEncabezado { get; set; }
        public int IdTipoDeEvaluacion { get; set; }
        public int anio { get; set; }
    }

    public class EntidadesTiposDeEvaluaciones : EntidadTokens
    {
        public int IdTipoDeEvaluacion { get; set; }
        public string TxtTipoDeEvaluacion { get; set; }
    }
}
