page 50710 MyRoleCenter
{
    PageType = RoleCenter;
    Caption = 'Simple Role Center';
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(RoleCenter)
        {
            group(Accueil)
            {
                Caption = 'Tableau de bord';

                part(Cues; 50711) // Référence à une page Cue
                {
                    ApplicationArea = All;
                   
                }
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group(Clients)
            {
                Caption = 'Gestion des clients';
                
                // action("Liste Clients")
                // {
                //     Caption = 'Voir Clients';
                //     ApplicationArea = All;
                //     RunObject = Page 22; // ID standard de "Customer List"
                // }

                action("Nouvelle Facture")
                {
                    Caption = 'Créer une Facture';
                    ApplicationArea = All;
                    RunObject = Page 43; 
                    RunPageMode = Create;
                }
            }
        }
    }
}

profile "Simple Profile"
{
    Caption = 'Profile Tesssst';
    RoleCenter =MyRoleCenter; 
    Description = 'Un profil de test avec un Role Center personnalisé.';
}
