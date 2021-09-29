//var UrlApi = "http://localHost:65405/api/";
//var UrlApi = "http://localHost:62062/api/";
var UrlApi = "https://www.api-canek.cetcom.edu.gt/api/";
function iniciodesesion(){
    var settings = {
        "url": UrlApi + "IniciodeSesion",
        "method": "POST",
        "timeout": 0,
        "headers": {
          "Content-Type": "application/json"
        },
        "data": JSON.stringify(
        {
            "TxtEmail":$("#TxtEmail").val(),
            "TxtPassword":$("#TxtPassword").val(),}),
      };
      
      $.ajax(settings).done(function (response) {
        console.log(response);
        $.each(response, function(index, response){
        if(response.IntResultado > 0){
            Swal.fire({
                position: 'top',
                icon: 'success',
                title: 'Bienvenido',
                showConfirmButton: false,
                timer: 2000,
              })
            Redirigir();
            LimpiarFormulario();
            sessionStorage.setItem("inicio", response.TxtToken);
            sessionStorage.setItem("Usuario", response.TxtUsuario);
        }else{
            Swal.fire({
                icon: 'error',
                title: 'Oops...',
                text: 'Algo salio mal!, intentalo de nuevo :D',
                footer: '<a href>Why do I have this issue?</a>'
              })
        }
    });
      });

     
}

function LimpiarFormulario(){
    $("#TxtEmail").val("");
    $("#TxtPassword").val("");
    //$("#IdOculto").val(0);
}

function Cancelar(){
    LimpiarFormulario();
}

function Redirigir(){
    location.href = "index.html";
}

function Loguear(){
    iniciodesesion();
}