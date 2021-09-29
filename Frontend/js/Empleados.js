//var UrlApi = "https://www.api-quixchan.cetcom.edu.gt/api/";
var UrlApi = "http://localHost:65405/api/";

function AgregarEmpleado(){
    var settings = {
        "url": UrlApi + "AgregarEmpleado",
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
        //console.log(response); 
        alert("Empleado Correctametne")
        LimpiarFormulario();
        ObtenerUsuarios();
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
        "method": "Post",
        "timeout": 0,
      };
      
      $.ajax(settings).done(function (response) {
        //console.log(response);
        LimpiarFormulario();
        $.each(response, function(index, data){
            var fila = "<tr><td>" + data.TxtNombres + 
            "</td><td>" + data.TxtDireccion +
            "</td><td>" + data.TxtEmail +
            "</td><td class ='Text-center'><a href='#' onclick='ObtenerDatosUsuario(" + data.IdUsuario + ");'>Editar</a>" + 
            "</td><td class ='Text-center'><a href='#' onclick='EliminarUsuario(" + data.IdUsuario + ");'>Eliminar</a></td></tr>";

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
                alert("Usuario Eliminado Correctamente");
                LimpiarFormulario();
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