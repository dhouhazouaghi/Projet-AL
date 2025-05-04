page 50701 "Employe Card"
{
    ApplicationArea = All;
    Caption = 'Employe Card';
    PageType = Card;
    SourceTable = Employe;
    UsageCategory = Administration;

      layout
    {
        area(content)
        {
            group("Informations Générales")
            {
                field("EmployeID"; Rec."EmployeID") { Editable = false; }
                field("Nom"; Rec."Nom") { }
                field("Prenom"; Rec."Prenom") { }
                field("DateNaissance"; Rec."DateNaissance") { }
                field("Poste"; Rec."Poste") { }
                field("Salaire"; Rec."Salaire") { }
                  // Ajout du champ de sélection du département
               // Ajout du champ de sélection du nom du département
                field("DepartementNom"; Rec."DepartementID")
                {
                    Caption = 'Département';
                    ApplicationArea = All;
                    // Utilisation de TableRelation pour afficher le nom du département
                    TableRelation = Departement."NomDepartement";
                    // Utiliser la colonne "NomDepartement" pour la sélection
                    ToolTip = 'Sélectionner le département';
                }
                field("Email"; Rec."Email") { }
                field("Numéro de Téléphone"; Rec."Numéro de Téléphone") { }
            }
        }
    }
}