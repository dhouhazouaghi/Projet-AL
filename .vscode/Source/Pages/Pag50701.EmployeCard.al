page 50701 "Employe Card"
{
    ApplicationArea = All;
    Caption = 'Employe Card';
    PageType = Card;
    SourceTable = Employe;
    UsageCategory = Administration;
    
    // Définir les catégories de promotion qui apparaîtront comme menu fixe en bas
    PromotedActionCategories = 'Nouveau,Traitement,Rapports,Formations,Congés,Gestion';

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
                field("DepartementNom"; Rec."DepartementID")
                {
                    Caption = 'Département';
                    ApplicationArea = All;
                    TableRelation = Departement."NomDepartement";
                    ToolTip = 'Sélectionner le département';
                }
                field("Email"; Rec."Email") { }
                field("Numéro de Téléphone"; Rec."Numéro de Téléphone") { }
            }
        }
    }

    actions
    {
        // Actions existantes
        area(processing)
        {
            group("Rapports")
            {
                action("Exporter PDF")
                {
                    ApplicationArea = All;
                    Caption = 'Exporter PDF';
                    Image = Print;
                    // Utiliser Category3 pour le menu Rapports
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true; // Apparaît uniquement dans le menu promu
                    
                    trigger OnAction()
                    begin
                        Message('Fonction Exporter PDF exécutée.');
                    end;
                }
                action("Imprimer Badge")
                {
                    ApplicationArea = All;
                    Caption = 'Imprimer Badge';
                    Image = PrintDocument;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    
                    trigger OnAction()
                    begin
                        Message('Impression du badge employé...');
                    end;
                }
            }

            group("Gestion")
            {
                action("Envoyer Email")
                {
                    ApplicationArea = All;
                    Caption = 'Envoyer Email';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    
                    trigger OnAction()
                    begin
                        Message('Email envoyé à l''employé.');
                    end;
                }
                action("Créer Événement RH")
                {
                    ApplicationArea = All;
                    Caption = 'Créer Événement RH';
                    Image = Activity;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    
                    trigger OnAction()
                    begin
                        Message('Création d''un événement RH.');
                    end;
                }
            }
            
            // Formation et Développement
            group("Formation")
            {
                Caption = 'Formation et Développement';
                Image = Setup;
                
                action("Planifier Formation")
                {
                    ApplicationArea = All;
                    Caption = 'Planifier Formation';
                    Image = Calendar;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    
                    trigger OnAction()
                    begin
                        Message('Planification d''une formation...');
                    end;
                }
                
                action("Compétences")
                {
                    ApplicationArea = All;
                    Caption = 'Gérer Compétences';
                    Image = Skills;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    
                    trigger OnAction()
                    begin
                        Message('Gestion des compétences...');
                    end;
                }
                
                action("Certifications")
                {
                    ApplicationArea = All;
                    Caption = 'Certifications';
                    Image = Certificate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    
                    trigger OnAction()
                    begin
                        Message('Gestion des certifications...');
                    end;
                }
            }
            
            // Congés et Absences
            group("Congés")
            {
                Caption = 'Congés et Absences';
                Image = Absence;
                
                action("Demande Congé")
                {
                    ApplicationArea = All;
                    Caption = 'Demande Congé';
                    Image = Holiday;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    
                    trigger OnAction()
                    begin
                        Message('Création d''une demande de congé...');
                    end;
                }
                
                action("Historique Congés")
                {
                    ApplicationArea = All;
                    Caption = 'Historique Congés';
                    Image = History;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    
                    trigger OnAction()
                    begin
                        Message('Affichage de l''historique des congés...');
                    end;
                }
                
                action("Solde Congés")
                {
                    ApplicationArea = All;
                    Caption = 'Solde Congés';
                    Image = Balance;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    
                    trigger OnAction()
                    begin
                        Message('Affichage du solde de congés...');
                    end;
                }
            }
        }
        
        // Actions de navigation (non incluses dans le menu fixe)
        area(navigation)
        {
            group("Employé")
            {
                Caption = 'Employé';
                Image = Employee;
                
                action("Historique")
                {
                    ApplicationArea = All;
                    Caption = 'Historique';
                    Image = History;
                    
                    trigger OnAction()
                    begin
                        Message('Affichage de l''historique de l''employé...');
                    end;
                }
                
                action("Documents")
                {
                    ApplicationArea = All;
                    Caption = 'Documents';
                    Image = Documents;
                    
                    trigger OnAction()
                    begin
                        Message('Gestion des documents de l''employé...');
                    end;
                }
            }
        }
    }
}