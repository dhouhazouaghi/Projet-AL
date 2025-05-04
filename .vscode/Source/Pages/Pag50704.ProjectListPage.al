page 50704 ProjectListPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Project;
    Caption = 'Projects';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
            field("ProjectID"; Rec."ProjectID")
{
    ApplicationArea = All;
    DrillDown = true;
    trigger OnDrillDown()
    begin
        Page.Run(Page::ProjectDocuumentPage, Rec);
    end;
}
                field("Nom"; Rec."Nom")
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                }
                field("StartDate"; Rec."StartDate")
                {
                    ApplicationArea = All;
                }
                field("EndDate"; Rec."EndDate")
                {
                    ApplicationArea = All;
                }
                field("Budget"; Rec."Budget")
                {
                    ApplicationArea = All;
                }
                field("Status"; Rec."Status") 
                {
                    ApplicationArea = All;
                }
            }
        }
    }
actions
    {
        area(Processing)
        {
            action("Open Project Details")
            {
                ApplicationArea = All;
                Caption = 'Open Project Details';
                Image = Document;
                trigger OnAction()
                begin
                    // Ouvre la page de détails du projet sélectionné
                    Page.Run(Page::ProjectDocuumentPage, Rec);
                end;
            }
        
        action("Generate Project Report")
{
    Caption = 'Generate Project Report';
    Image = Print;
    ApplicationArea = All;

    trigger OnAction()
    var
        ProjectReport: Report "Project Report";
    begin
        ProjectReport.Run();
    end;
}

    }
    }
    }