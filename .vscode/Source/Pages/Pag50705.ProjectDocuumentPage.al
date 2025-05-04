page 50705 ProjectDocuumentPage
{
    ApplicationArea = All;
    Caption = 'Project Details';
    PageType = Document;
    SourceTable = Project;
    UsageCategory = Documents;
 layout
    {
        area(Content)
        {
            group("Project Information")
            {
                field("ProjectID"; Rec."ProjectID")
                {
                    ApplicationArea = All;
                    Editable = false; 
                }
                field("Nom"; Rec."Nom")
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                }
            }

            group("Dates & Budget")
            {
                field("StartDate"; Rec."StartDate")
                {
                    ApplicationArea = All;
                }
                field("EndDate"; Rec."EndDate")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        if Rec."EndDate" < Rec."StartDate" then
                            Error('La date de fin ne peut pas être antérieure à la date de début.');
                    end;
                }
                field("Budget"; Rec."Budget")
                {
                    ApplicationArea = All;
                }
            }

            group("Statut")
            {
                field("Status"; Rec."Status") 
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Validate Project")
            {
                ApplicationArea = All;
                Caption = 'Validate Project';
                Image = Approve;  // Ajout d'une icône pour une meilleure visibilité
                trigger OnAction()
                begin
                    Message('Project validated successfully!');
                end;
            }
        }
    }
}