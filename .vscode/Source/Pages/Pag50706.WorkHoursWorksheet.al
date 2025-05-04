page 50706 "Work Hours Worksheet"
{
    ApplicationArea = All;
    Caption = 'Feuille de Travail des Heures';
    PageType = Worksheet;
    SourceTable = "Work Hours";
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("EmployeID"; Rec."EmployeID")
                {
                    ApplicationArea = All;
                    Caption = 'Employé';
                }
                field("Nom Employé"; Rec."Nom Employé")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("DateTravail"; Rec."DateTravail")
                {
                    ApplicationArea = All;
                }
                field("HeuresTravaillees"; Rec."HeuresTravaillees")
                {
                    ApplicationArea = All;
                }
                field("Validé"; Rec."Validé")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ValidateEntries)
            {
                Caption = 'Valider les Heures';
                ApplicationArea = All;
                Image = Approve;

                trigger OnAction()
                var
                    WorkHoursRec: Record "Work Hours";
                begin
                    WorkHoursRec.Reset();
                    WorkHoursRec.SetRange(Validé, false);
                    if WorkHoursRec.FindFirst() then begin
                        repeat
                            WorkHoursRec.Validé := true;
                            WorkHoursRec.Modify();
                        until WorkHoursRec.Next() = 0;
                        Message('Toutes les entrées ont été validées.');
                    end
                    else
                        Message('Aucune entrée à valider.');
                end;
            }
        }
    }
}