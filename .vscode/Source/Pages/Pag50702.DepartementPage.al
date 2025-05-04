page 50702 DepartementPage
{
    PageType = List;
    SourceTable = Departement;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Départements';

  layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("DepartementID"; Rec."DepartementID")
                {
                    Caption = 'ID Département';
                    Editable = false; // ID auto-incrémenté

                    trigger OnDrillDown()
                    begin
                        // Ouvre la page DepartementCard relative à cet ID
                        Page.RunModal(50703, Rec);
                    end;
                }
                field("NomDepartement"; Rec."NomDepartement")
                {
                    Caption = 'Nom du Département';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Créer Département")
            {
                Caption = 'Créer un Département';
                Image = Add;
                ApplicationArea = All;

                trigger OnAction()
                var
                    DepartementRec: Record Departement;
                begin
                    Clear(DepartementRec);
                    if Page.RunModal(50703, DepartementRec) = Action::OK then
                        DepartementRec.Insert();
                end;
            }

            action("Supprimer Département")
            {
                Caption = 'Supprimer le Département';
                Image = Delete;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Confirm('Voulez-vous vraiment supprimer ce département ?', false) then
                        Rec.Delete();
                end;
            }
        }
    }
}