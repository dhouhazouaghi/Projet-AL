var addin = document.getElementById('controlAddIn'); //Récupère l'élément HTML avec l'ID controlAddIn
addin.innerHTML = '<div id="myProgress"><div id="myBar">0%</div></div>';
//Ajoute dynamiquement une barre de progression dans controlAddIn en insérant du HTML
var CurrentProgress = 0;
//Crée une variable CurrentProgress et lui donne une valeur initiale de 0%
Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('IAmReady',[]);
//Informe Business Central que l'Add-in est prêt via IAmReady