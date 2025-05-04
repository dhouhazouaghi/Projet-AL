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

    // trigger OnInsert()
    // begin
    //     ValidateDependency();
    // end;

    // trigger OnModify()
    // begin
    //     ValidateDependency();
    // end;

    // local procedure ValidateDependency()
    // var
    //     DependencyChain: List of [Code[20]];
    // begin
    //     if "Predecessor Job Task No." = "Job Task No." then
    //         Error('Une tâche ne peut pas dépendre d’elle-même. Tâche : %1', "Job Task No.");

    //     DependencyChain.Add("Job Task No.");
    //     CheckForCircularDependency("Predecessor Job Task No.", DependencyChain);
    // end;

    // local procedure CheckForCircularDependency(TaskNo: Code[20]; Chain: List of [Code[20]])
    // var
    //     DepRec: Record "Job Task Dependency";
    //     NextTask: Code[20];
    // begin
    //     if Chain.Contains(TaskNo) then
    //         Error('Dépendance circulaire détectée à partir de la tâche %1.', TaskNo);

    //     Chain.Add(TaskNo);

    //     DepRec.SetRange("Job No.", "Job No.");
    //     DepRec.SetRange("Job Task No.", TaskNo);

    //     if DepRec.FindSet() then
    //         repeat
    //             NextTask := DepRec."Predecessor Job Task No.";
    //             CheckForCircularDependency(NextTask, Chain);
    //         until DepRec.Next() = 0;
    // end;
}
