table 50700 Employe
{
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "EmployeID"; Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;

        }
        field(2; "Nom"; Text[50])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if Nom = '' then
                    Error('Le nom ne peut pas être vide.');
            end;
        }
        field(3; "Prenom"; Text[50])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if Prenom = '' then
                    Error('Le prénom ne peut pas être vide.');
            end;
        }
        field(4; "DateNaissance"; Date)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if DateNaissance > Today then
                    Error('La date de naissance ne peut pas être dans le futur.');
            end;
        }
        field(5; "Poste"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Salaire"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if Salaire < 0 then
                    Error('Le salaire ne peut pas être négatif.');
            end;
        }
        ////////////////// Relation avec la table Département
           field(7; "DepartementID"; Integer)
        {
            Caption = 'Département';
            TableRelation = Departement."DepartementID"; 
            
        }
  
     field(8; "Email"; Text[100])
        {
            Caption = 'Email';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                RegEx: Codeunit "Text Management"; //////////////////////////////////////////////////////////////
            begin
                if "Email" <> '' then begin
                    if not RegEx.IsValidEmail("Email") then
                        Error('Veuillez entrer une adresse e-mail valide.');
                end;
            end;
        }

        field(9; "Numéro de Téléphone"; Text[20])
        {
            Caption = 'Numéro de Téléphone';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                PhoneRegex: Codeunit "Text Management";
            begin
                if "Numéro de Téléphone" <> '' then begin
                    if not PhoneRegex.IsValidPhone("Numéro de Téléphone") then
                        Error('Le numéro de téléphone n''est pas valide.');
                end;
            end;
        } 

         }
    keys
    {
        key(PK; "EmployeID") { Clustered = true; }
    }
}