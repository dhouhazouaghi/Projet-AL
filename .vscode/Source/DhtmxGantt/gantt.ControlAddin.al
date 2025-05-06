controladdin gantt
{
    Scripts = 'gantt/dhtmlxgantt.js', 
              'gantt/gantt.js',
              'gantt/Zoom.js',
              'gantt/Export.js';
    StartupScript = 'gantt/startup.js';
    StyleSheets = 'gantt/dhtmlxgantt.css',
                  'gantt/custom-gantt.css';
    VerticalStretch = true;
    HorizontalStretch = true;

    event ControlReady();
    procedure Load(Data: JsonObject);
    procedure ZoomIn();
    procedure ZoomOut();
    procedure RefreshGantt(Data: JsonObject);
    procedure ExportToPDF()
    procedure ExportToPNG()
}
