controladdin GanttControlAddIn
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

    // Events
    event ControlReady();
    event OnTaskUpdate(TaskData: JsonObject);
    event OnTaskDelete(taskId: Text);
    event OnTaskCreate(taskData: JsonObject);
    event OnLinkDelete(linkData: JsonObject);
    event OnLinkCreate(linkData: JsonObject);
    event OnAddProject();

    // Procedures
    procedure Load(Data: JsonObject);
    procedure LoadResources(Data: JsonObject);
    procedure ZoomIn();
    procedure ZoomOut();
    procedure Refresh(Data: JsonObject);
    procedure ExportGanttToPDF();
    
    procedure ExportToPNG();
}