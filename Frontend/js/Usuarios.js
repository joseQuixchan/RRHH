//var UrlApi = "http://localHost:65405/api/";
//var UrlApi = "http://localHost:62062/api/";
var UrlApi = "http://api-ef-quixchan.cetcom.edu.gt/api/";

function AgregarUsuario(){
    var settings = {
        "url": UrlApi + "AgregarUsuario",
        "method": "POST",  
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "TxtNombres": $("#TxtNombres").val(),
            "TxtApellidos": $("#TxtApellidos").val(),
            "TxtDireccion": $("#TxtDireccion").val(),
            "TxtEmail": $("#TxtEmail").val(),
            "TxtPassword": $("#TxtPassword").val(),
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        $.each(response, function(index, data){
            if(data.Resultado>0){
              Swal.fire({
                position: 'top-end',
                icon: 'success',
                title: 'Usuario Agregado',
                showConfirmButton: false,
                timer: 1500
              })
              LimpiarFormulario();
              ObtenerUsuarios();
            }else{
              alert("Opss... Algo salio mal :( ")
            }
        });
      });
}

function LimpiarFormulario(){
        $("#TxtNombres").val("");
        $("#TxtApellidos").val("");
        $("#TxtDireccion").val("");
        $("#TxtEmail").val("");
        $("#TxtPassword").val("");
        $("IdOculto").val(0);

}

function ObtenerUsuarios(){
    $("#TblUsuarios td").remove();
    var settings = {
        "url": UrlApi + "ObtenerUsuarios",
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
            var fila = "<tr class='row100 body'><td class='cell100 column1'>" + data.TxtNombres + 
            "</td><td class='cell100 column2'>" + data.TxtDireccion +
            "</td><td class='cell100 column3'>" + data.TxtEmail +
            "</td><td class ='Text-center cell100 column3'><a href='#' onclick='ObtenerDatosUsuario(" + data.IdUsuario + ");'>Editar</a>" + 
            "</td><td class ='Text-center cell100 column3'><a href='#' onclick='EliminarUsuario(" + data.IdUsuario + ");'>Eliminar</a></td></tr>";

            $(fila).appendTo("#TblUsuarios");
        });
      });
}

function EliminarUsuario(IdUsuario){
    var settings = {
        "url": UrlApi + "EliminarUsuario",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdUsuario": IdUsuario,
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        $.each(response, function(index, data){
            if(data.Resultado>0){
             Swal.fire({
                position: 'top-end',
                icon: 'success',
                title: 'Usuario ELiminado',
                showConfirmButton: false,
                timer: 1500
              })
              ObtenerUsuarios();
            }else{
                alert("Error: EL Usuario no fue eliminado")
            }
        });
      });
}

function ObtenerDatosUsuario(IdUsuario){
    var settings = {
        "url": UrlApi + "ObtenerDatosUsuario",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdUsuario": IdUsuario,
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        
        LimpiarFormulario();
        $("#IdOculto").val(IdUsuario);

        $.each(response, function(index, data){
            $("#TxtNombres").val(data.TxtNombres);
            $("#TxtApellidos").val(data.TxtApellidos);
            $("#TxtDireccion").val(data.TxtDireccion);
            $("#TxtEmail").val(data.TxtEmail);
            $("#TxtPassword").val(data.TxtPassword);

        });
      });
}

function ActualizarUsuario(){
    var settings = {
        "url": UrlApi + "ActualizarUsuario",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify({
            "IdUsuario": $("#IdOculto").val(),
            "TxtNombres": $("#TxtNombres").val(),
            "TxtApellidos": $("#TxtApellidos").val(),
            "TxtDireccion": $("#TxtDireccion").val(),
            "TxtEmail": $("#TxtEmail").val(),
            "TxtPassword": $("#TxtPassword").val(),
            "TxtToken": sessionStorage.getItem("inicio")
        }),
      };
      
      $.ajax(settings).done(function (response) {
        $.each(response, function(index, data){
            if(data.Resultado>0){
                alert("Usuario Actualizado Correctamente");
                LimpiarFormulario();
                ObtenerUsuarios();
            }else{
                alert("Error: EL Usuario no fue actualizado")
            }
        });
      });
}

function Guardar(){
    if($("#IdOculto").val() > 0){
        ActualizarUsuario();

    }else{
        AgregarUsuario();
    }
}

