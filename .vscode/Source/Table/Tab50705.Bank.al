table 50705 Bank
{
    Caption = 'Bank';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Bank No.';
            DataClassification = ToBeClassified;
        }

        field(2; Name; Text[100])
        {
            Caption = 'Bank Name';
            DataClassification = ToBeClassified;
        }

        field(3; "Bank Branch No."; Code[20])
        {
            Caption = 'Bank Branch No.';
            DataClassification = ToBeClassified;
        }

        field(4; "Balance (LCY)"; Decimal)
        {
            Caption = 'Balance (LCY)';
            DataClassification = ToBeClassified;
        }

        field(5; CompanyName; Text[100])
        {
            Caption = 'Company Name';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
    }
}

