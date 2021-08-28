function sign_in(){
    var light = document.getElementById("body_light");
    light.style.display = "block";
    var dialog = document.getElementById("dialogOrd");
    dialog.style.display = "block";
}

function dialogExit(){
    var light = document.getElementById("body_light");
    light.style.display = "none";
    var dialog = document.getElementById("dialogOrd");
    dialog.style.display = "none";
}