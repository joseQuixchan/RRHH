using System;

namespace Entidades
{
    public class EntidadesEvaluacionesAplicadasEncabezado: EntidadTokens
    {
        public int IdEvaluacionAplicadaEncabezado { get; set; }
        public int IdEvaluacionEncabezado { get; set; }
        public int IdEmpleado { get; set; }
        public DateTime FechaDeAplicacion { get; set; }
        public DateTime FechaInicial { get; set; }
        public DateTime FechaFinal { get; set; }
        public Decimal DbPunteoTotal { get; set; }
        public string TxtObservacionesDeJefe { get; set; }
        public string TxtObservacionesDeEmpleado { get; set; }
        public int IntNecesitaPlanDeMejora { get; set; }


    }
}
