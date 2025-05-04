controladdin MyProgressBar
{
    Scripts = 'script.js';
    StartupScript = 'startup.js'; //exécuté dès le démarrage du contrôle
    StyleSheets = 'progress.css';
    MinimumHeight = 50;
    MaximumHeight = 50;
    HorizontalStretch = true;

    event IAmReady();
    //Cet evnmt est déclenché par le JS pour signaler à BC que le contrôle est prêt à être utilisé
    procedure SetProgress(Progress: Integer);
    //permet à Business Central d'envoyer une valeur de progression
}
