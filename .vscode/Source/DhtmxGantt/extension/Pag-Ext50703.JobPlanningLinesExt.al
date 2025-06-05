namespace ALProject.ALProject;

using Microsoft.Projects.Project.Planning;

pageextension 50703 "Job Planning Lines Ext" extends "Job Planning Lines"
{
    layout
    {
        addafter(Quantity)
        {
            field("Progress Rate"; ProgressRateValue)
            {
                ApplicationArea = All;
                Caption = 'Progress Rate (%)';
                DecimalPlaces = 2 : 2;
                Editable = false;
                ToolTip = 'Affiche le taux de progression (Qty. Posted / Quantity * 100).';
                StyleExpr = ProgressRateStyle;
            }
            field("Progress Status"; StatusValue)
            {
                ApplicationArea = All;
                Caption = 'Progress Status';
                Editable = false;
                ToolTip = 'Statut basé sur le taux de progression : To Do, In Progress, Done.';
                StyleExpr = StatusStyle;
            }
        }
    }
    
    var
        ProgressRateValue: Decimal;
        ProgressRateStyle: Text;
        StatusValue: Text[20];
        StatusStyle: Text;
    
    trigger OnAfterGetRecord()
    begin
        CalcProgressRate();
        CalcProgressStatus();
        SetProgressRateStyle();
        SetStatusStyle();
    end;
    
    local procedure CalcProgressRate()
    begin
        if Rec.Quantity <> 0 then begin
            ProgressRateValue := (Rec."Qty. Posted" / Rec.Quantity) * 100;
            if ProgressRateValue > 100 then
                ProgressRateValue := 100;
        end else
            ProgressRateValue := 0;
    end;
    
    local procedure SetProgressRateStyle()
    begin
        case true of
            ProgressRateValue = 100:
                ProgressRateStyle := 'Favorable';
            ProgressRateValue >= 75:
                ProgressRateStyle := 'Attention';
            ProgressRateValue >= 50:
                ProgressRateStyle := 'Subordinate';
            else
                ProgressRateStyle := 'Unfavorable';
        end;
    end;
    
    local procedure CalcProgressStatus()
    begin
        case true of
            ProgressRateValue = 100:
                StatusValue := 'Done';
            ProgressRateValue > 0:
                StatusValue := 'In Progress';
            else
                StatusValue := 'To Do';
        end;
    end;
    
    local procedure SetStatusStyle()
    begin
        case StatusValue of
            'Done':
                StatusStyle := 'Favorable'; // Vert
            'In Progress':
                StatusStyle := 'Attention'; // Orange
            'To Do':
                StatusStyle := 'Subordinate'; // Bleu/Gris
        end;
    end;
}