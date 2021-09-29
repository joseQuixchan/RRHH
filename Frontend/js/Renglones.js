//var UrlApi = "http://localHost:62062/api/";
var UrlApi = "http://localHost:65405/api/";
//var UrlApi = "https://www.api-quixchan.cetcom.edu.gt/api/";

function AgregarRenglon(){
    var settings = {
        "url": UrlApi + "AgregarRenglon",
        "method": "POST",  
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "TxtRenglon": $("#TxtRenglon").val(),
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        $.each(response, function(index, data){
            if(data.Resultado>0){
              Swal.fire({
                position: 'top-end',
                icon: 'success',
                title: 'Renglon Agregado',
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
        $("#TxtRenglon").val("");
        $("IdOculto").val(0);

}

function ObtenerRenglones(){
    $("#TblRenglones td").remove();
    var settings = {
        "url": UrlApi + "ObtenerRenglones",
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
            var fila = "<tr class='row100 body'><td class='cell100 column1'>" + data.TxtRenglon + 
            "</td><td class='Text-center cell100 column2'><a href='#' onclick='ObtenerDatosRenglon(" + data.IdRenglon + ");'>Editar</a>" + 
            "</td><td class='Text-center cell100 column2'><a href='#' onclick='EliminarRenglon(" + data.IdRenglon + ");'>Eliminar</a></td></tr>";

            $(fila).appendTo("#TblRenglones");
        });
      });
}

function EliminarRenglon(IdRenglon){
    var settings = {
        "url": UrlApi + "EliminarRenglon",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdRenglon": IdRenglon,
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        $.each(response, function(index, data){
            if(data.Resultado>0){  
                Swal.fire({
                  position: 'top-end',
                  icon: 'success',
                  title: 'Renglon Eliminado',
                  showConfirmButton: false,
                  timer: 1500
                })
                LimpiarFormulario();
                ObtenerRenglones();
            }else{
                alert("Opss... Algo salio mal :( ")
            }
        });
      });
}

function ObtenerDatosRenglon(IdRenglon){
    var settings = {
        "url": UrlApi + "ObtenerDatosRenglon",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdRenglon": IdRenglon,
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        
        LimpiarFormulario();
        $("#IdOculto").val(IdRenglon);

        $.each(response, function(index, data){
            $("#TxtRenglon").val(data.TxtRenglon);

        });
      });
}

function ActualizarRenglon(){
    var settings = {
        "url": UrlApi + "ActualizarRenglon",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdRenglon": $("#IdOculto").val(),
            "TxtRenglon": $("#TxtRenglon").val(),
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        $.each(response, function(index, data){
            if(data.Resultado>0){
                Swal.fire({
                  position: 'top-end',
                  icon: 'success',
                  title: 'Renglon Actualizado',
                  showConfirmButton: false,
                  timer: 1500
                })
                LimpiarFormulario();
                ObtenerRenglones();
            }else{
                alert("Opss... Algo salio mal :( ")
            }
        });
      });
}

function Guardar(){
    if($("#IdOculto").val() > 0){
        ActualizarRenglon();

    }else{
        AgregarRenglon();
    }
}