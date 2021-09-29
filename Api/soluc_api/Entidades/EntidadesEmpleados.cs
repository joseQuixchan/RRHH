using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entidades
{
    public class EntidadesEmpleados : EntidadTokens
    {
        public int IdEmpleado { get; set; }
        public string TxtNit { get; set; }
        public string TxtDpi { get; set; }
        public string TxtNombres { get; set; }
        public string TxtApellidos { get; set; }
        public int IdPuesto { get; set; }
        public int IdEspecialidad { get; set; }
        public int IdServicio { get; set; }
        public int IdRenglon { get; set; }
    }

    public class EntidadesEspecialidades : EntidadTokens
    {
        public int IdEspecialidad { get; set; }
        public String TxtEspecialidad { get; set; }
    }

    public class EntidadesPuestos : EntidadTokens
    {
        public int IdPuesto { get; set; }
        public string TxtPuesto { get; set; }
    }


    public class EntidadesRenglones : EntidadTokens
    {
        public int IdRenglon { get; set; }
        public string TxtRenglon { get; set; }
    }


    public class EntidadesServicios : EntidadTokens
    {
        public int IdServicio { get; set; }
        public string TxtServicio { get; set; }
    }
}
