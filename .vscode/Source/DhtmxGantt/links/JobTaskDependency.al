table 50706 "Job Task Dependency"
{
    Caption = 'Job Task Dependency';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
            DataClassification = ToBeClassified;
        }
        field(2; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));
            DataClassification = ToBeClassified;
        }
        field(3; "Predecessor Job Task No."; Code[20])
        {
            Caption = 'Predecessor Job Task No.';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));
            DataClassification = ToBeClassified;
        }
    field(4; "Dependency Type"; Enum "Job Task Dependency Type")
        {
            Caption = 'Dependency Type';
            DataClassification = ToBeClassified;
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Job No.", "Job Task No.", "Line No.")
        {
            Clustered = true;
        }

        key(Secondary; "Job No.", "Predecessor Job Task No.") { }
    }

    
}
