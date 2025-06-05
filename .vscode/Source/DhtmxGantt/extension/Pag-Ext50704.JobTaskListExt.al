namespace ALProject.ALProject;

using Microsoft.Projects.Project.Job;

pageextension 50704 "Job Task List Ext" extends "Job Task List"
{
    layout
    {
        addafter(Description)
        {
            field("Task Progress Rate"; TaskProgressRateValue)
            {
                ApplicationArea = All;
                Caption = 'Task Progress Rate (%)';
                DecimalPlaces = 2 : 2;
                Editable = false;
                ToolTip = 'Taux de progression moyen des lignes de planification associées à cette tâche.';
                StyleExpr = ProgressRateStyle;
            }
            field("Task Status"; TaskStatusValue)
            {
                ApplicationArea = All;
                Caption = 'Task Status';
                Editable = false;
                ToolTip = 'Statut de la tâche basé sur le taux de progression : To Do, In Progress, Done.';
                StyleExpr = StatusStyle;
            }
        }
    }
    
    var
        TaskProgressRateValue: Decimal;
        TaskStatusValue: Text[20];
        ProgressRateStyle: Text;
        StatusStyle: Text;
    
    trigger OnAfterGetRecord()
    begin
        CalcTaskProgress();
        CalcTaskStatus();
        SetProgressRateStyle();
        SetStatusStyle();
    end;
    
    local procedure CalcTaskProgress()
    begin
        TaskProgressRateValue := Rec.CalcTaskProgressRate();
    end;
    
    local procedure CalcTaskStatus()
    begin
        TaskStatusValue := Rec.CalcTaskStatus();
    end;
    
    local procedure SetProgressRateStyle()
    begin
        case true of
            TaskProgressRateValue = 100:
                ProgressRateStyle := 'Favorable';
            TaskProgressRateValue >= 75:
                ProgressRateStyle := 'Attention';
            TaskProgressRateValue >= 50:
                ProgressRateStyle := 'Subordinate';
            else
                ProgressRateStyle := 'Unfavorable';
        end;
    end;
    
    local procedure SetStatusStyle()
    begin
        case TaskStatusValue of
            'Done':
                StatusStyle := 'Favorable'; // Vert
            'In Progress':
                StatusStyle := 'Attention'; // Orange
            'To Do':
                StatusStyle := 'Subordinate'; // Bleu/Gris
        end;
    end;
}