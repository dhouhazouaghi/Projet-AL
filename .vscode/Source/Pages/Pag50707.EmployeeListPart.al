page 50707 "Employee ListPart"
{
    ApplicationArea = All;
    Caption = 'Employee ListPart';
    PageType = ListPart;
    SourceTable = Employe;    
    UsageCategory = Lists;
    
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("EmployeID"; Rec."EmployeID")
                {
                    ApplicationArea = All;
                }
                field("Nom"; Rec."Nom")
                {
                    ApplicationArea = All;
                }
                field("Prenom"; Rec."Prenom")
                {
                    ApplicationArea = All;
                }
                field("Poste"; Rec."Poste")
                {
                    ApplicationArea = All;
                }
                field("Salaire"; Rec."Salaire")
                {
                    ApplicationArea = All;
                }
                field("DepartementNom"; Rec."DepartementID")
                {
                    ApplicationArea = All;
                    TableRelation = Departement."NomDepartement";
                }
                
            }
        }
    }
}