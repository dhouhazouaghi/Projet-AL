namespace ALProject.ALProject;

using Microsoft.Projects.Project.Job;
using Microsoft.Projects.Project.Planning;

tableextension 50702 "Job Task Ext" extends "Job Task"
{
    fields
    {
        field(50100; "Task Progress Rate"; Decimal)
        {
            Caption = 'Task Progress Rate';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(50101; "Task Status"; Text[20])
        {
            Caption = 'Task Status';
            Editable = false;
        }
    }
    
    procedure CalcTaskProgressRate(): Decimal
    var
        JobPlanningLine: Record "Job Planning Line";
        TotalProgressRate: Decimal;
        LineCount: Integer;
        LineProgressRate: Decimal;
        AvgProgressRate: Decimal;
    begin
        TotalProgressRate := 0;
        LineCount := 0;
        
        JobPlanningLine.SetRange("Job No.", "Job No.");
        JobPlanningLine.SetRange("Job Task No.", "Job Task No.");
        
        if JobPlanningLine.FindSet() then begin
            repeat
                // Calculer le taux de progression pour chaque ligne
                if JobPlanningLine.Quantity <> 0 then
                    LineProgressRate := (JobPlanningLine."Qty. Posted" / JobPlanningLine.Quantity) * 100
                else
                    LineProgressRate := 0;
                    
                // Limiter à 100% par ligne
                if LineProgressRate > 100 then
                    LineProgressRate := 100;
                    
                TotalProgressRate += LineProgressRate;
                LineCount += 1;
            until JobPlanningLine.Next() = 0;
        end;
        
        // Calculer la moyenne arithmétique
        if LineCount > 0 then
            AvgProgressRate := TotalProgressRate / LineCount
        else
            AvgProgressRate := 0;
            
        "Task Progress Rate" := AvgProgressRate;
        exit(AvgProgressRate);
    end;
    
    procedure CalcTaskStatus(): Text[20]
    var
        ProgressRate: Decimal;
        StatusText: Text[20];
    begin
        ProgressRate := CalcTaskProgressRate();
        
        case true of
            ProgressRate = 100:
                StatusText := 'Done';
            ProgressRate > 0:
                StatusText := 'In Progress';
            else
                StatusText := 'To Do';
        end;
        
        "Task Status" := StatusText;
        exit(StatusText);
    end;
}