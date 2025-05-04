table 50703 "Work Hours"
{
    DataClassification = ToBeClassified;
    Caption = 'Feuille des Heures de Travail';

    fields
    {
        field(1; "EntryID"; Integer)
        {
            Caption = 'ID Saisie';
            AutoIncrement = true;
        }
        field(2; "EmployeID"; Integer)
        {
            Caption = 'Employé';
            TableRelation = Employe."EmployeID";
        }
        field(3; "Nom Employé"; Text[50])
        {
            Caption = 'Nom Employé';
            FieldClass = FlowField;
            CalcFormula = Lookup(Employe."Nom" WHERE("EmployeID" = FIELD("EmployeID")));
        }
        field(4; "DateTravail"; Date)
        {
            Caption = 'Date de Travail';
        }
        field(5; "HeuresTravaillees"; Decimal)
        {
            Caption = 'Heures Travaillées';
        }
        field(6; "Validé"; Boolean)
        {
            Caption = 'Validé';
        }
    }

    keys
    {
        key(PK; "EntryID") { Clustered = true; }
    }
}