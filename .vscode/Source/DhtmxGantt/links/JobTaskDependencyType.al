namespace ALProject.ALProject;

enum 50701 "Job Task Dependency Type"
{
    Extensible = true;
    Caption = 'Job Task Dependency Type';
    
    value(0; "Finish-to-Start") 
    { 
        Caption = 'Finish-to-Start'; 
    }
    value(1; "Start-to-Start") 
    { 
        Caption = 'Start-to-Start'; 
    }
    value(2; "Finish-to-Finish") 
    { 
        Caption = 'Finish-to-Finish'; 
    }
    value(3; "Start-to-Finish") 
    { 
        Caption = 'Start-to-Finish'; 
    }
    }