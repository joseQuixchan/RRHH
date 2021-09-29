//var UrlApi = "http://localHost:62062/api/";
//var UrlApi = "http://localHost:65405/api/";
var UrlApi = "https://www.api-canek.cetcom.edu.gt/api/";

function AgregarPuesto(){
    var settings = {
        "url": UrlApi + "AgregarPuesto",
        "method": "POST",  
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "TxtPuesto": $("#TxtPuesto").val(),
            "TxtToken": sessionStorage.getItem("inicio")
        }),
        console
      };
      
      $.ajax(settings).done(function (response) {
        $.each(response, function(index, data){
            if(data.Resultado>0){
              Swal.fire({
                position: 'top-end',
                icon: 'success',
                title: 'Puesto Agregado',
                showConfirmButton: false,
                timer: 1500
              })

              LimpiarFormulario();
              ObtenerPuestos();
              
            }else{
              alert("Opss... Algo salio mal :( ")
            }
        });
      });
}

function LimpiarFormulario(){
        $("#TxtPuesto").val("");
        $("IdOculto").val(0);

}

function ObtenerPuestos(){
    $("#TblPuestos td").remove();
    var settings = {
        "url": UrlApi + "ObtenerPuestos",
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
            var fila = "<tr class='row100 body'><td class='cell100 column1'>" + data.TxtPuesto + 
            "</td><td class='Text-center cell100 column2'><a href='#' onclick='ObtenerDatosPuesto(" + data.IdPuesto + ");'>Editar</a>" + 
            "</td><td class='Text-center cell100 column2'><a href='#' onclick='EliminarPuesto(" + data.IdPuesto + ");'>Eliminar</a></td></tr>";

            $(fila).appendTo("#TblPuestos");
        });
      });
}

function EliminarPuesto(IdPuesto){
    var settings = {
        "url": UrlApi + "EliminarPuesto",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdPuesto": IdPuesto,
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        $.each(response, function(index, data){
            if(data.Resultado>0){  
                Swal.fire({
                  position: 'top-end',
                  icon: 'success',
                  title: 'Puesto Eliminado',
                  showConfirmButton: false,
                  timer: 1500
                })
                LimpiarFormulario();
                ObtenerPuestos();
            }else{
                alert("Opss... Algo salio mal :( ")
            }
        });
      });
}

function ObtenerDatosPuesto(IdPuesto){
    var settings = {
        "url": UrlApi + "ObtenerDatosPuesto",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdPuesto": IdPuesto,
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        
        LimpiarFormulario();
        $("#IdOculto").val(IdPuesto);

        $.each(response, function(index, data){
            $("#TxtPuesto").val(data.TxtPuesto);

        });
      });
}

function ActualizarPuesto(){
    var settings = {
        "url": UrlApi + "ActualizarPuesto",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdPuesto": $("#IdOculto").val(),
            "TxtPuesto": $("#TxtPuesto").val(),
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        $.each(response, function(index, data){
            if(data.Resultado>0){
                Swal.fire({
                  position: 'top-end',
                  icon: 'success',
                  title: 'Puesto Actualizado',
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

function Guardar(){
    if($("#IdOculto").val() > 0){
        ActualizarPuesto();

    }else{
        AgregarPuesto();
    }
}