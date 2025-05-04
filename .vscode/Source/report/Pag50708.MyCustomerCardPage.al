page 50708 MyCustomerCardPage
{
    ApplicationArea = All;
    Caption = 'MyCustomerCardPage';
    PageType = Card;
    SourceTable = CustomerTable;
    UsageCategory = Administration;
    layout
    {
        area(content)
        {
            group(CustomerInfo)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RunCustomerReport)
            {
                Caption = 'Run Customer Report';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Report.Run(50700,true, false);
                end;
            }
        }
    }
}