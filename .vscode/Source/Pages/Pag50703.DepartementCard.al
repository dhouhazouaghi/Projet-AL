page 50703 DepartementCard
{
    PageType = Card;
    SourceTable = Departement;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Fiche Département';

 layout
    {
        area(content)
        {
            group("Department Information")
            {
                field("DepartementID"; Rec."DepartementID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("NomDepartement"; Rec."NomDepartement")
                {
                    ApplicationArea = All;
                }
            }
////////////////////////////////////////////////////// PART //////////////////////////
            part("EmployeesList"; "Employee ListPart") // Intégrer la page ListPart
            {
               ApplicationArea = All;
                Caption = 'Employés';
                SubPageLink = "DepartementID" = field("DepartementID"); // Filtrage des employés selon le département sélectionné
        }
    }
}
}