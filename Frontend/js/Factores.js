//var UrlApi = "http://localHost:62062/api/";
var UrlApi = "http://localHost:65405/api/";
//var UrlApi = "https://www.api-quixchan.cetcom.edu.gt/api/";

function AgregarFactor(){
    var settings = {
        "url": UrlApi + "AgregarFactor",
        "method": "POST",  
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "TxtFactor": $("#TxtFactor").val(),
            "TxtDescripcion": $("#TxtDescripcion").val(),
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        $.each(response, function(index, data){
            if(data.Resultado>0){
              Swal.fire({
                position: 'top-end',
                icon: 'success',
                title: 'Servicio Agregado',
                showConfirmButton: false,
                timer: 1500
              })

              LimpiarFormulario();
              ObtenerFactores();
              
            }else{
              alert("Opss... Algo salio mal :( ")
            }
        });
      });
}

function LimpiarFormulario(){
        $("#TxtFactor").val("");
        $("#TxtDescripcion").val("");
        $("IdOculto").val(0);

}

function ObtenerFactores(){
    $("#TblFactores td").remove();
    var settings = {
        "url": UrlApi + "ObtenerFactores",
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
            var fila = "<tr class='row100 body'><td class='cell100 column1'>" + data.TxtFactor + 
            "</td><td class='cell100 column2'>" + data.TxtDescripcion +
            "</td><td class='Text-center cell100 column2'><a href='#' onclick='ObtenerDatosFactor(" + data.IdFactor + ");'>Editar</a>" + 
            "</td><td class='Text-center cell100 column2'><a href='#' onclick='EliminarFactor(" + data.IdFactor + ");'>Eliminar</a></td></tr>";

            $(fila).appendTo("#TblFactores");
        });
      });
}

function EliminarFactor(IdFactor){
    var settings = {
        "url": UrlApi + "EliminarFactor",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdFactor": IdFactor,
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        $.each(response, function(index, data){
            if(data.Resultado>0){  
                Swal.fire({
                  position: 'top-end',
                  icon: 'success',
                  title: 'Servicio Eliminado',
                  showConfirmButton: false,
                  timer: 1500
                })
                LimpiarFormulario();
                ObtenerFactores();
            }else{
                alert("Opss... Algo salio mal :( ")
            }
        });
      });
}

function ObtenerDatosFactor(IdFactor){
    var settings = {
        "url": UrlApi + "ObtenerDatosFactor",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdFactor": IdFactor,
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        
        LimpiarFormulario();
        $("#IdOculto").val(IdFactor);

        $.each(response, function(index, data){
            $("#TxtFactor").val(data.TxtFactor);
            $("#TxtDescripcion").val(data.TxtDescripcion);

        });
      });
}

function ActualizarFactor(){
    var settings = {
        "url": UrlApi + "ActualizarFactor",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdFactor": $("#IdOculto").val(),
            "TxtFactor": $("#TxtFactor").val(),
            "TxtDescripcion": $("#TxtDescripcion").val(),
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        $.each(response, function(index, data){
            if(data.Resultado>0){
                Swal.fire({
                  position: 'top-end',
                  icon: 'success',
                  title: 'Servicio Actualizado',
                  showConfirmButton: false,
                  timer: 1500
                })
                LimpiarFormulario();
                ObtenerFactores();
            }else{
                alert("Opss... Algo salio mal :( ")
            }
        });
      });
}

function Guardar(){
    if($("#IdOculto").val() > 0){
        ActualizarFactor();

    }else{
        AgregarFactor();
    }
}