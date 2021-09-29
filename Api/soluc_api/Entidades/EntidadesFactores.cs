using System;

namespace Entidades
{
    public class EntidadesFactores: EntidadTokens
    {
        public int IdFactor { get; set; }
        public String TxtFactor { get; set; }
        public String TxtDescripcion { get; set; }
    }

    public class EntidadesSubFactores: EntidadTokens
    {
        public int IdSubFactor { get; set; }
        public String TxtSubFactor { get; set; }
        public String TxtDescripcion { get; set; }
    }
}
