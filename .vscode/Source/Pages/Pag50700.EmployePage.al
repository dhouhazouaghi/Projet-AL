page 50700 EmployePage
{
    ApplicationArea = All;
    Caption = 'EmployePage';
    PageType = List;
    SourceTable = Employe;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("EmployeID"; Rec."EmployeID") { }
                field("Nom"; Rec."Nom") { }
                field("Prenom"; Rec."Prenom") { }
                field("DateNaissance"; Rec."DateNaissance") { }
                field("Poste"; Rec."Poste") { }
                field("Salaire"; Rec."Salaire") { }
                // Affichage du Nom du Département dans la table, au lieu de l'ID
                field("DepartementID"; Rec."DepartementID")
                {
                    Caption = 'Département';
                    Lookup = true; // Permet d'afficher la liste des départements
                    // Utilisation d'une relation de table pour afficher le NomDepartement
                    TableRelation = "Departement"."NomDepartement";
                }
                field("Email"; Rec."Email") { }
                field("Numéro de Téléphone"; Rec."Numéro de Téléphone") { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Créer Employé")  //ne fonctionne pas correctement 
            {
                Caption = 'Créer un Employé';
                Image = Add;
                ApplicationArea = All;

                trigger OnAction()
                var
                    EmployeRec: Record "Employe";
                begin
                    Clear(EmployeRec);
                    if Page.RunModal(50701, EmployeRec) = Action::OK then
                        EmployeRec.Insert();
                end;
            }

            action("Supprimer Employé")
            {
                Caption = 'Supprimer Employé';
                Image = Delete;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if Rec.Get(Rec."EmployeID") then //Récupère l’employé sélectionné
                    begin
                        if Confirm('Voulez-vous vraiment supprimer cet employé ?', false) then //Demande une confirmation
                        begin
                            Rec.Delete();
                            Message('Employé supprimé avec succès.');
                        end;
                    end;
                end;
            }
            // Action pour générer et afficher le rapport EmployeReport
            action("Générer Rapport Employés")
            {
                Caption = 'Générer Rapport Employés';
                Image = Report;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ReportID: Integer;
                begin
                    ReportID := 50701; // ID du rapport "Employe Report"
                    // Exécuter le rapport en passant les paramètres nécessaires (s'il y en a)
                    REPORT.RUN(ReportID);
                end;
            }
        }
    }
}