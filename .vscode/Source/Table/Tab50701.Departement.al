table 50701 Departement
{
    DataClassification = ToBeClassified;
    Caption = 'Département';

    fields
    {
        field(1; "DepartementID"; Integer)
        {
            Caption = 'ID Département';
            AutoIncrement = true;
        }
        field(2; "NomDepartement"; Text[50])
        {
            Caption = 'Nom Département';
        }
    }

    keys
    {
        key(PK; "DepartementID")
        {
            Clustered = true;
        }
    }
}
