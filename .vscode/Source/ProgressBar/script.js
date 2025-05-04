function SetProgress(progress) {
    var elem = document.getElementById("myBar"); //Sélectionne l'élément HTML <div id="myBar"> 
    elem.style.width = progress + "%"; //Change la largeur (width) de l'élément myBar pour qu'elle corresponde à progress%   
    elem.innerHTML = progress + "%"; //Met à jour le texte à l'intérieur de la barre avec la valeur de progress%

}