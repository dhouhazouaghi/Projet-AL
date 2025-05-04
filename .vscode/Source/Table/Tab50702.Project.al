table 50702 Project
{
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "ProjectID"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }

        field(2; "Nom"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(3; "Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }

        field(4; "StartDate"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(5; "EndDate"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(6; "Budget"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Status"; Enum "Project Status")
{
    DataClassification = ToBeClassified;
}

    }

    keys
    {
        key(PK; "ProjectID")
        {
            Clustered = true;
        }
    }

    
}