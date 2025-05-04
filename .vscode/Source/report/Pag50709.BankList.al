page 50709 "Bank List"
{
    ApplicationArea = All;
    Caption = 'Bank List';
    PageType = List;
    SourceTable = Bank;
    UsageCategory = Lists;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Name; Rec.Name) { ApplicationArea = All; }
                field("Bank Branch No."; Rec."Bank Branch No.") { ApplicationArea = All; }
                field("Balance (LCY)"; Rec."Balance (LCY)") { ApplicationArea = All; }
                field(CompanyName; Rec.CompanyName) { ApplicationArea = All; }
            }
        }
    }
}