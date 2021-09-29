//var UrlApi = "http://localHost:62062/api/";
var UrlApi = "http://localHost:65405/api/";
//var UrlApi = "https://www.api-quixchan.cetcom.edu.gt/api/";

function AgregarSubFactor(){
    var settings = {
        "url": UrlApi + "AgregarSubFactor",
        "method": "POST",  
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "TxtSubFactor": $("#TxtSubFactor").val(),
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
              ObtenerSubFactores();
              
            }else{
              alert("Opss... Algo salio mal :( ")
            }
        });
      });
}

function LimpiarFormulario(){
        $("#TxtSubFactor").val("");
        $("#TxtDescripcion").val("");
        $("IdOculto").val(0);

}

function ObtenerSubFactores(){
    $("#TblSubFactores td").remove();
    var settings = {
        "url": UrlApi + "ObtenerSubFactores",
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
            var fila = "<tr class='row100 body'><td class='cell100 column1'>" + data.TxtSubFactor + 
            "</td><td class='cell100 column2'>" + data.TxtDescripcion +
            "</td><td class='Text-center cell100 column2'><a href='#' onclick='ObtenerDatosSubFactor(" + data.IdSubFactor + ");'>Editar</a>" + 
            "</td><td class='Text-center cell100 column2'><a href='#' onclick='EliminarSubFactor(" + data.IdSubFactor + ");'>Eliminar</a></td></tr>";

            $(fila).appendTo("#TblSubFactores");
        });
      });
}

function EliminarSubFactor(IdSubFactor){
    var settings = {
        "url": UrlApi + "EliminarSubFactor",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdSubFactor": IdSubFactor,
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
                ObtenerSubFactores();
            }else{
                alert("Opss... Algo salio mal :( ")
            }
        });
      });
}

function ObtenerDatosSubFactor(IdSubFactor){
    var settings = {
        "url": UrlApi + "ObtenerDatosSubFactor",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdSubFactor": IdSubFactor,
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        
        LimpiarFormulario();
        $("#IdOculto").val(IdSubFactor);

        $.each(response, function(index, data){
            $("#TxtSubFactor").val(data.TxtSubFactor);
            $("#TxtDescripcion").val(data.TxtDescripcion);

        });
      });
}

function ActualizarSubFactor(){
    var settings = {
        "url": UrlApi + "ActualizarSubFactor",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdSubFactor": $("#IdOculto").val(),
            "TxtSubFactor": $("#TxtSubFactor").val(),
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
        ActualizarSubFactor();

    }else{
        AgregarSubFactor();
    }
}