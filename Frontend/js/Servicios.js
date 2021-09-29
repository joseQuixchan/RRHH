//var UrlApi = "http://localHost:62062/api/";
var UrlApi = "http://localHost:65405/api/";
//var UrlApi = "https://www.api-quixchan.cetcom.edu.gt/api/";

function AgregarServicio(){
    var settings = {
        "url": UrlApi + "AgregarServicio",
        "method": "POST",  
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "TxtServicio": $("#TxtServicio").val(),
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
              ObtenerServicios();
              
            }else{
              alert("Opss... Algo salio mal :( ")
            }
        });
      });
}

function LimpiarFormulario(){
        $("#TxtServicio").val("");
        $("IdOculto").val(0);

}

function ObtenerServicios(){
    $("#TblServicios td").remove();
    var settings = {
        "url": UrlApi + "ObtenerServicios",
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
            var fila = "<tr class='row100 body'><td class='cell100 column1'>" + data.TxtServicio + 
            "</td><td class='Text-center cell100 column2'><a href='#' onclick='ObtenerDatosServicio(" + data.IdServicio + ");'>Editar</a>" + 
            "</td><td class='Text-center cell100 column2'><a href='#' onclick='EliminarServicio(" + data.IdServicio + ");'>Eliminar</a></td></tr>";

            $(fila).appendTo("#TblServicios");
        });
      });
}

function EliminarServicio(IdServicio){
    var settings = {
        "url": UrlApi + "EliminarServicio",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdServicio": IdServicio,
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
                ObtenerServicios();
            }else{
                alert("Opss... Algo salio mal :( ")
            }
        });
      });
}

function ObtenerDatosServicio(IdServicio){
    var settings = {
        "url": UrlApi + "ObtenerDatosServicio",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdServicio": IdServicio,
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        
        LimpiarFormulario();
        $("#IdOculto").val(IdServicio);

        $.each(response, function(index, data){
            $("#TxtServicio").val(data.TxtServicio);

        });
      });
}

function ActualizarServicio(){
    var settings = {
        "url": UrlApi + "ActualizarServicio",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdServicio": $("#IdOculto").val(),
            "TxtServicio": $("#TxtServicio").val(),
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
                ObtenerServicios();
            }else{
                alert("Opss... Algo salio mal :( ")
            }
        });
      });
}

function Guardar(){
    if($("#IdOculto").val() > 0){
        ActualizarServicio();

    }else{
        AgregarServicio();
    }
}