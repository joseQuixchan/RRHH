//var UrlApi = "http://localHost:62062/api/";
var UrlApi = "http://localHost:65405/api/";
//var UrlApi = "https://www.api-quixchan.cetcom.edu.gt/api/";

function AgregarEspecialidad(){
    var settings = {
        "url": UrlApi + "AgregarEspecialidad",
        "method": "POST",  
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "TxtEspecialidad": $("#TxtEspecialidad").val(),
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        $.each(response, function(index, data){
            if(data.Resultado>0){
              Swal.fire({
                position: 'top-end',
                icon: 'success',
                title: 'Especialidad Agregada',
                showConfirmButton: false,
                timer: 1500
              })
              LimpiarFormulario();
              ObtenerEspecialidades();
            }else{
              alert("Opss... Algo salio mal :( ")
            }
        });
      });
}

function LimpiarFormulario(){
        $("#TxtEspecialidad").val("");
        $("IdOculto").val(0);

}

function ObtenerEspecialidades(){
    $("#TblEspecialidades td").remove();
    var settings = {
        "url": UrlApi + "ObtenerEspecialidades",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
          "TxtToken": sessionStorage.getItem("inicio")
        })
      };
      
      $.ajax(settings).done(function (response) {
        LimpiarFormulario();
        $.each(response, function(index, data){
            var fila = "<tr class='row100 body'><td class='cell100 column1'>" + data.TxtEspecialidad + 
            "</td><td class='Text-center cell100 column2'><a href='#' onclick='ObtenerDatosEspecialidad(" + data.IdEspecialidad + ");'>Editar</a>" + 
            "</td><td class='Text-center cell100 column2'><a href='#' onclick='EliminarEspecialidad(" + data.IdEspecialidad + ");'>Eliminar</a></td></tr>";

            $(fila).appendTo("#TblEspecialidades");
        });
      });
}

function EliminarEspecialidad(IdEspecialidad){
    var settings = {
        "url": UrlApi + "EliminarEspecialidad",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdEspecialidad": IdEspecialidad,
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        $.each(response, function(index, data){
            if(data.Resultado>0){  
                Swal.fire({
                  position: 'top-end',
                  icon: 'success',
                  title: 'Especialidad Eliminada',
                  showConfirmButton: false,
                  timer: 1500
                })
                LimpiarFormulario();
                ObtenerEspecialidades();
            }else{
                alert("Error: La Especialidad no fue eliminada")
            }
        });
      });
}

function ObtenerDatosEspecialidad(IdEspecialidad){
    var settings = {
        "url": UrlApi + "ObtenerDatosEspecialidad",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdEspecialidad": IdEspecialidad,
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        
        LimpiarFormulario();
        $("#IdOculto").val(IdEspecialidad);

        $.each(response, function(index, data){
            $("#TxtEspecialidad").val(data.TxtEspecialidad);

        });
      });
}

function ActualizarEspecialidad(){
    var settings = {
        "url": UrlApi + "ActualizarEspecialidad",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdEspecialidad": $("#IdOculto").val(),
            "TxtEspecialidad": $("#TxtEspecialidad").val(),
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        $.each(response, function(index, data){
            if(data.Resultado>0){
                Swal.fire({
                  position: 'top-end',
                  icon: 'success',
                  title: 'Especialidad Agregada',
                  showConfirmButton: false,
                  timer: 1500
                })
                LimpiarFormulario();
                ObtenerEspecialidades();
            }else{
                alert("Error: La Especialidad no fue actualizada")
            }
        });
      });
}

function Guardar(){
    if($("#IdOculto").val() > 0){
        ActualizarEspecialidad();

    }else{
        AgregarEspecialidad();
    }
}