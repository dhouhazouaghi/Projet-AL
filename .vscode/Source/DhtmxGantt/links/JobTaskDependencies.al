page 50714 "Job Task Dependencies"
{
    ApplicationArea = All;
    Caption = 'Job Task Dependencies';
    PageType = ListPart;
    SourceTable = "Job Task Dependency";
    AutoSplitKey = true;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Predecessor Job Task No."; Rec."Predecessor Job Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'La tâche prédécesseur de cette tâche.';
                }
                field("Dependency Type"; Rec."Dependency Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Type de dépendance avec la tâche prédécesseur.';
                    ShowCaption = true; 
                }
            }
        }
    }
}
