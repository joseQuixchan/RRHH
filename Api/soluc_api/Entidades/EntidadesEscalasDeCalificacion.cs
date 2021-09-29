using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entidades
{
    public class EntidadesEscalasDeCalificacion: EntidadTokens
    {
        public int IdEscalaDeCalificacion { get; set; }
        public String TxtEscalaDeCalificacion { get; set; }
        public decimal DbPunteo { get; set; }
        public String TxtDescripcion { get; set; }

    }
}
